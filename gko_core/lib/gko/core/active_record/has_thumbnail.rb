module HasThumbnail
  attr_reader :thumbnail_attribute

  def has_thumbnail(accessor_name)
    include InstanceMethods
    @thumbnail_attribute = accessor_name.to_sym
    image_accessor self.thumbnail_attribute #do 
                                            # @see http://markevans.github.com/dragonfly/file.Models.html#Callbacks for explanations
                                            #after_assign do |a| # 'a' is the attachment itself
                                            # a.name = self.class.thumbnail_attribute.name.parameterize
                                            # Tells IM to strip the image of any profiles or comments,
                                            # which you probably don’t need and which helps to reduce the size of the image.
                                            # Note: Photoshop stores and obtains image resolution from a proprietary embedded profile.
                                            # If this profile exists in the image, then Photoshop will
                                            # continue to treat the image using its former resolution,
                                            # ignoring the image resolution specified in the standard file header.
                                            # If you send a 300dpi photoshop image and transfor it to 72 dpi if you do not strip
                                            # the file photoshop will continue to treat it as a 300 dpi file.
                                            #a.convert!("-strip")
                                            # Ensure resolution is at 72 dpi.
                                            #a.convert!("-density 72")
                                            # Use Convert : To resize the image so that it is the same size at a different resolution
                                            # a.convert!("-resample 72")
                                            #a.convert!("-colorspace rgb")
                                            # TODO How to define min/max value
                                            #geom = a.landscape? ? '1200x1000^' : '1000x1200^'
                                            #geometries =  image_sizes
                                            #if geometries.keys.include?(:storage)
                                            #  geom = geometries[:storage]
                                            #elsif geometries.keys.include?(:large)
                                            #  geom = geometries[:large]
                                            #end
                                            #a.process!(:resize, geom) if geom
                                            #end
                                            #end
                                            #validates accessor_name.to_sym, :length => { :maximum => MAX_SIZE_IN_MB.megabytes }

                                            #validates_property :mime_type, :of => accessor_name.to_sym, :in => FILE_TYPES,
                                            #                   :message => :incorrect_file_type


    def self.image_size
      #'80x'
    end

                                            # What is the max image size a user can upload
    def self.max_thumbnail_size
      1
    end

                                            # What is the max image format a user can upload
    def self.file_types
      %w(image/jpg image/jpeg image/png image/gif)
    end

  end

  module InstanceMethods

    def thumbnail(geometry = nil)
      a = self.class.thumbnail_attribute
      if image = self.send(a)
        #g = geometry || self.class.image_size || "self.send(#{a}_width)"x"self.send(#{a}_height)"
        # Rails.logger.info("******* #{g}")
        image.thumb
      end
    end
  end
end

ActiveRecord::Base.extend(HasThumbnail)