class Category < ActiveRecord::Base

  include Extensions::Models::BelongsToSection
  include Extensions::Models::Translatable
  include Extensions::Models::TouchAncestors

  TRANSLATED_FIELD = [
    :title, :body, :meta_title, :meta_description, :slug, :path
  ].freeze

  translates *TRANSLATED_FIELD

  class Translation
    attr_accessible :locale
  end

  has_many :categorizations, :dependent => :destroy
  has_many :spectacle_events, :through => :categorizations, :as => :categorizable
  acts_as_nested_set :dependent => :destroy, :scope => :section_id
  attr_accessible :title, :body, :meta_title, :meta_description, :slug, :name, :parent_id

  ## class methods ##

  def self.translated
    with_globalize.nested_set
  end

  def self.live
    with_globalize
  end

  def self.nested_set
    order("lft ASC")
  end

  # Retrieve a section by its unique identifier over the site.  
  def self.named(name)
    where(:name => name).first
  end
  
  
  def self.in_use
    translated.joins(:categorizations).where('categorizations.category_id is not null').group('categorizations.category_id')
  end
  
  #----- Validations -----------------------------------------------------------

  validates :title, :presence => true

  #----- Callbacks -----------------------------------------------------------

  before_move :touch_ancestors, :if => proc { |m| m.child? }
  after_move :touch_ancestors #if parent changed ?

  before_validation do |r|
    r.slug = r.title if (r.slug.blank? && r.title.present?)
    r.slug = transliterate_slug(r.slug) if (slug_changed? && r.slug.present?)
    r.update_path if r.slug_changed? || r.parent_id_changed?
  end

  after_move do |r|
    r.update_path
    r.save
  end

  after_save do |r|
    r.descendants.map do |child|
      child.update_path
      child.save
    end if @path_dirty
    @path_dirty = false
  end

  # Get public url for the specified locale
  def public_url(locale=nil)
    locale ||= ::Globalize.locale
    p = self.permalink(locale)
    return nil unless p.presence
    u = [section.permalink, "categories", p]
    u.unshift(locale.to_s) if (locale.to_sym != site.default_locale)
    u = u.join('/')
    u = '/' + u
    u
  end

  def permalink(locale=nil)
    locale ||= ::Globalize.locale
    read_attribute(:path, :locale => locale)
  end

  # Get public urls for all locales
  def public_urls
    urls = []
    self.used_locales.each do |l|
      urls << self.public_url(l)
    end
    urls.flatten.compact.uniq
  end

  def save_translations!
    update_path if self.path_changed?
    super
  end

  def update_path
    new_path = self.ancestors.push(self).map(&:slug).compact.join('/')
    new_path.slice!(0) if new_path.start_with?('/')
    unless self.path == new_path
      self.path = new_path
      @path_dirty = true
    end
  end

  protected

  def transliterate_slug(input)
    transliteration = case ::Globalize.locale.to_sym
    #when :bg  then :bulgarian
    #when :da  then :danish
    when :de  then :german
      #when :gr  then :greek
      #when :mk  then :macedonian
      #when :no  then :norwegian
      #when :ro  then :romanian
    when :ru  then :russian
      #when :bg  then :serbian
    when :pt  then :spanish
    when :br  then :spanish
    when :es  then :spanish
      #when :se  then :swedish
    end
    if transliteration.presence
      input.to_s.to_slug.normalize(:transliterate => true, :transliterations => transliteration).to_s
    else
      input.to_s.to_slug.normalize.to_s
    end
  end

end
