class Sticker < ActiveRecord::Base
  
  include Extensions::Models::BelongsToSection
  include Extensions::Models::Translatable
  
  attr_accessor :size
  
  TRANSLATED_FIELD = [
    :name, :path
  ].freeze

  translates *TRANSLATED_FIELD


  belongs_to :section, :touch => true
  has_many :stickings, :dependent => :destroy
  
  validates :section_id, :presence => true 
  validates :name, :presence => true, :uniqueness => {:scope => :section_id}

  attr_accessible :section, :section_id, :name, :path, :css
  
  before_save :normalize_path, :if => proc { |m| m.name && m.name_changed? }

  class << self
    def translated
      with_translations(::Globalize.locale).order("sticker_translations.name")
    end

    # Finds a sticker using its name.  This method is necessary because stickers
    # are translated which means the name attribute does not exist on the
    # stickers table thus requiring us to find the attribute on the translations table
    # and then join to the stickers table again to return the associated record.
    def by_name(name)
      with_globalize(:name => name)
    end
    alias :named :by_name

    # Returns an array of tags with a count attribute
    def counts(options={})
      with_scope(:find => {
          :select => "stickers.id, stickers.name, count(*) as count",
          :joins => :stickings,
          :group => "stickers.id, stickers.name",
          :order => "count desc,stickers.name"}) do
        all(options)
      end
    end

    # Returns an array of tags with a size attribute
    # This takes the same arguments as find, plus the additional `:sizes` option,
    # which contols the number of sizes the tag cloud will have.
    # The default number of sizes is 5.
    def cloud(options={})
      #sizes = (options.delete(:sizes) || 5) - 1
      sizes = 4
      sizes = 1 if sizes < 1
      stickers = counts(options)
      return [] if stickers.blank?
      min = nil
      max = nil
      stickers.each do |t|
        t.count = t.count.to_i
        min = t.count if (min.nil? || t.count < min)
        max = t.count if (max.nil? || t.count > min)
      end
      divisor = ((max - min) / sizes) + 1
      stickers.each do |t|
        t.size = ("%1.0f" % (t.count * 1.0 / divisor)).to_i
      end
      stickers
    end



  end

  #----- Instance Methods ------------------------------------------------------
  def sticking_count
    stickings.count
  end

  def next(field = "name")
    self.class.next(self, field).first
  end

  def previous(field = "name")
    self.class.previous(self, field).first
  end

  # Get public url for the specified locale
  def public_url(locale=nil)
    locale ||= ::Globalize.locale
    p = self.permalink(locale)
    return nil unless p.present?
    u = [self.section.path(locale), 'tags', p]
    u.unshift(locale.to_s) if (locale.to_sym != site.default_locale.to_sym)
    u = u.join('/')
    u = '/' + u
    u
  end

  def permalink(locale=nil)
    locale ||= ::Globalize.locale
    read_attribute(:path, :locale => locale.to_sym)
  end

  # Get public urls for all locales
  def public_urls
    urls = []
    self.used_locales.each do |l|
      urls << self.public_url(l)
    end
    urls.flatten.compact.uniq
  end
  
  protected
  
  def normalize_path
    self.path = self.name.clone.parameterize
  end
end
