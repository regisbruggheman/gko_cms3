#http://railscasts.com/episodes/182-cropping-images
# encoding: utf-8

class Image < ActiveRecord::Base

  belongs_to_site

  # What is the max image size a user can upload
  MAX_SIZE_IN_MB = 6
  # What is the max image format a user can upload
  FILE_TYPES = %w(image/jpg image/jpeg image/png image/gif image/tiff)

  image_accessor :image do
    # @see http://markevans.github.com/dragonfly/file.Models.html#Callbacks for explanations
    after_assign do |a| # 'a' is the attachment itself
      a.name = image.name.parameterize
      # Tells IM to strip the image of any profiles or comments,
      # which you probably don’t need and which helps to reduce the size of the image.
      # Note: Photoshop stores and obtains image resolution from a proprietary embedded profile.
      # If this profile exists in the image, then Photoshop will
      # continue to treat the image using its former resolution,
      # ignoring the image resolution specified in the standard file header.
      # If you send a 300dpi photoshop image and transfor it to 72 dpi if you do not strip
      # the file photoshop will continue to treat it as a 300 dpi file.
      a.convert!("-strip")
      # Ensure resolution is at 72 dpi.
      a.convert!("-density 72")

    end
  end

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title]

  delegate :size, :mime_type, :url, :width, :height, :to => :image

  has_many :image_assignments, :dependent => :destroy
  has_and_belongs_to_many :image_folders
  accepts_nested_attributes_for :image_folders

  # allows Mass-Assignment
  attr_accessible :id, :image, :image_size, :image_folder_ids, :video_url, :author

  validates :image, :presence => {}, :length => {:maximum => MAX_SIZE_IN_MB.megabytes}

  validates_property :mime_type, :of => :image, :in => FILE_TYPES, :message => :incorrect_file_type

  validates_property :width,
                     :of => :image, :in => (100..3000),
                     :message => I18n.t(:'activerecord.errors.models.image.incorrect_dimensions', :min => 100, :max => 3000)

  after_update do |r|
    r.image_assignments.each do |m|
      m.attachable.touch
    end
  end

  ## class methods ##

  class << self

    def with_query(q)
      where("images.image_name LIKE ?", "%#{q}%")
    end

    def with_size_over(v)
      where("images.image_size > ?", v.to_i)
    end

    def with_size_under(v)
      where("images.image_size < ?", v.to_i)
    end

    def with_width_over(v)
      where("images.image_width > ?", v.to_i)
    end

    def with_width_under(v)
      where("images.image_width < ?", v.to_i)
    end

    def with_height_over(v)
      where("images.image_height > ?", v.to_i)
    end

    def with_height_under(v)
      where("images.image_height < ?", v.to_i)
    end

    def unused
      where("images.image_assignments_count = ?", 0)
    end

  end

  def image_sizes
    @image_sizes ||= self.site.image_sizes
  end

  # Get a thumbnail job object given a geometry.
  def thumbnail(geometry = nil)
    if geometry.is_a?(Symbol) and image_sizes.keys.include?(geometry)
      geometry = image_sizes[geometry]
    end

    if geometry.present? && !geometry.is_a?(Symbol)
      image.thumb(geometry.to_s)
    else
      image
    end
  end

  def portrait?
    self.image_width.to_f < self.image_height.to_f
  end

  # Intelligently works out dimensions for a thumbnail of this image based on the Dragonfly geometry string.
  def thumbnail_dimensions(geometry)
    geometry = geometry.to_s
    width = original_width = self.image_width.to_f
    height = original_height = self.image_height.to_f
    geometry_width, geometry_height = geometry.split(%r{\#{1,2}|\+|>|!|x}im)[0..1].map(&:to_f)
    if (original_width * original_height > 0) && ::Dragonfly::ImageMagick::Processor::THUMB_GEOMETRY === geometry
      if ::Dragonfly::ImageMagick::Processor::RESIZE_GEOMETRY === geometry
        if geometry !~ %r{\d+x\d+>} || (%r{\d+x\d+>} === geometry && (width > geometry_width.to_f || height > geometry_height.to_f))
          # Try scaling with width factor first. (wf = width factor)
          wf_width = (original_width * geometry_width / width).round
          wf_height = (original_height * geometry_width / width).round

          # Scale with height factor (hf = height factor)
          hf_width = (original_width * geometry_height / height).round
          hf_height = (original_height * geometry_height / height).round

          # Take the highest value that doesn't exceed either axis limit.
          use_wf = wf_width <= geometry_width && wf_height <= geometry_height
          if use_wf && hf_width <= geometry_width && hf_height <= geometry_height
            use_wf = wf_width * wf_height > hf_width * hf_height
          end

          if use_wf
            width = wf_width
            height = wf_height
          else
            width = hf_width
            height = hf_height
          end
        end
      else
        # cropping
        width = geometry_width
        height = geometry_height
      end
    end

    { :width => width.to_i, :height => height.to_i }
  end

  # Returns a titleized version of the filename
  # my_file.jpg returns My File
  def title
    CGI::unescape(image_name.to_s).gsub(/\.\w+$/, '').titleize
  end
end
