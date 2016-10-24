class Section < ActiveRecord::Base

  belongs_to :site, :inverse_of => :sections, :touch => true
  has_many :text_elements, :inverse_of => :section, :dependent => :destroy do
    def named(key)
      where(:text_elements => {:key => key}).first
    end
  end
  accepts_nested_attributes_for :text_elements
  validates :site_id, :presence => true
  attr_accessible :site, :site_id, :text_elements_attributes

  include Extensions::Models::Translatable
  include Extensions::Models::Publishable
  include Extensions::Models::IsPolymorphic
  include Extensions::Models::TouchAncestors
  include Extensions::Models::HasManyImageAssignments
  include Extensions::Models::HasManyDocumentAssignments

  TRANSLATED_FIELD = [
    :title,
    :body,
    :meta_description,
    :meta_title,
    :slug,
    :menu_title,
    :path,
    :redirect_url,
    :alt
  ].freeze

  translates :title,
    :body,
    :meta_description,
    :meta_title,
    :slug,
    :menu_title,
    :path,
    :redirect_url,
    :alt

  class Translation
    attr_accessible :locale
  end

  ## virtual attributes ##

  ## options ##
  has_option :deletable, :default => true, :type => :boolean
  has_option :display_first_page, :default => false, :type => :boolean
  has_option :menu_css_class, :default => "", :type => :string
  has_option :body_css_class, :default => "", :type => :string
  has_option :html_head, :default => "", :type => :text
  has_option :show_title_in_page, :default => true, :type => :boolean

  acts_as_nested_set(
    :dependent => :destroy,
    :scope => :site_id)

  ## behaviours ##
  attr_accessible(
    :alt,
    :body,
    :hidden,
    :layout,
    :template,
    :link_id,
    :link_type,
    :restricted,
    :menu_title,
    :meta_title,
    :meta_description,
    :name,
    :options,
    :parent_id,
    :path,
    :published_at,
    :redirect_url,
    :robot_follow,
    :robot_index,
    :slug,
    :title,
    :type)

  ## class methods ##

  def self.cached_key(site = Site.current)
    Globalize.locale.to_s + "/" + Digest::MD5.hexdigest("sections-#{site.sections.maximum(:updated_at)}.try(:to_i)-#{site.sections.count}")
  end

  def self.nested_set
    order('sections.lft ASC')
  end

  def self.indexable
    where(:robot_index => true, :restricted => false).where('sections.type not in (?)', ['Redirect'])
  end

  #def self.live(conditions = {})
  #  published.with_globalize(conditions)
  #end

  # Retrieve a section by its unique identifier over the site.
  def self.named(name)
    where(:name => name).first
  end

  # Shows all pages with :show_in_menu set to true, but it also
  # rejects any page that has not been translated to the current locale
  # and page that are flagged as draft.
  # This works using a query against the translated content first and then
  # using all of the page_ids we further filter against this model's table.
  def self.in_menu
    live(:hidden => false)
  end

  ## callbacks ##
  before_validation :ensure_site_presence, :if => proc { |m| m.site_id.blank? && m.parent_id.present? }
  before_validation :normalize_slug
  before_validation :update_path, :if => proc { |m| m.slug_changed? || m.parent_id_changed? }
  before_validation :normalize_name, :unless => proc { |m| m.parent_id.present? }, :on => :create

  before_save :inherit_restricted_status, :if => proc { |m| m.parent && m.parent.restricted? }
  before_save { |m| m.translation.save }
  before_move :touch_ancestors, :if => proc { |m| m.child? }
  after_move :touch_ancestors
  after_move :update_path_and_save
  after_save :update_descendants_path, :unless => proc { |m| m.site.preferred_flat_slug }
  after_save :set_restrictions_to_child_pages, :if => proc { |m| m.restricted_changed? }

  ## validations ##

  validates :title,
            :presence => true,
            :uniqueness => {:scope => [:site_id, :parent_id], :case_sensitive => false}
  validates :slug, :presence => true,
            :uniqueness => {:scope => [:site_id, :parent_id], :case_sensitive => false},
            :if => "need_slug?"
  validates :name,
            :presence => true,
            :unless => "parent_id.present?"
  validates :name,
            :uniqueness => {:scope => :site_id},
            :if => "name.present?"

  # FIXME bad alias as menus are root but not home
  alias :home? :root?

  def type
    read_attribute(:type) || 'Page'
  end

  def permalink(locale = I18n.locale)
    root? ? '' : read_attribute(:path, :locale => locale.to_sym)
  end

  # Get public url for the specified locale
  def public_url(locale=nil)
    #Rails.cache.fetch("public_url-#{Globalize.locale}-#{self.cache_key}") do
      locale ||= ::Globalize.locale
      p = self.permalink(locale)
      return nil unless p.presence
      u = [p]
      u.unshift(locale.to_s) if (locale.to_sym != site.default_locale.to_sym)
      u = u.join('/')
      u = '/' + u
      u
    #end
  end

  # Get public urls for all locales
  def public_urls
    #Rails.cache.fetch("public_urls-#{Globalize.locale}-#{self.cache_key}") do
      urls = []
      self.used_locales.each do |l|
        urls << self.public_url(l)
      end
      urls.compact.uniq
    #end
  end

  def live_urls
    #Rails.cache.fetch("live_urls-#{Globalize.locale}-#{self.cache_key}") do
      urls = []
      self.site.available_locales.each do |language|
        urls << self.public_url(language.code.to_sym)
      end
      urls.compact.uniq
    #end
  end

  def content_type
    nil
  end

  # roots does not need slug
  def need_slug?
    child?
  end

  def update_path
    return unless need_slug?

    new_path = self.site.preferred_flat_slug ? self.slug : self.ancestors.push(self).map(&:slug).compact.join('/')
    new_path.slice!(0) if new_path.start_with?('/') #due to root which has no slug !?
    if self.path != new_path
      self.path = new_path
      @path_dirty = true if !self.site.preferred_flat_slug
    end
  end

  def labelize
    @label = self.menu_title.blank? ? :title : :menu_title
    translated_locales.include?(Globalize.locale) ? self.send(@label) : "<span class='label warning'>!</span>(#{read_attribute(@label, :locale => I18n.default_locale)})".html_safe
  end

  #
  #def parsed_body
  #  if self.body.present?
  #    doc = ::Nokogiri::HTML(self.body)
  #    all_tags = doc.xpath("//img")
  #    all_tags.each do | img_tag |
  #      image_name = img_tag['src'].split('/').last.split('?').first
  #      if image = Image.find_by_image_name(image_name)
  #        img_tag['src'] = image.thumbnail(:medium).url().to_s
   #       img_tag['title'] = image.image_name.to_s
  #        img_tag['alt'] = image.image_name.to_s
  #        img_tag['data-id'] = image.id.to_s
  #        img_tag['data-url'] = image.thumbnail(:large).url().to_s
  #      end
   #   end
   #   doc.css("body").inner_html
  #  end
 # end


  def categorizable?
    self.content_type.presence && self.site.has_plugin?(:categories) && self.accept_categories
  end

  def stickable?
    self.content_type.presence && self.site.has_plugin?(:stickers) and self.accept_stickers
  end

  def commentable?
    self.site.has_plugin?(:comments) and self.accept_comments
  end

  def admin_cache_key
    "admin/#{Globalize.locale.to_s}/#{self.site.cache_key}/" + self.cache_key
  end

  def collection_timestamp
    "#{self.site.updated_at.try(:to_i)}-#{self.send(self.collection_table_name).maximum(:updated_at).try(:to_i)}-#{self.send(self.collection_table_name).count}" if self.content_type
  end

  def collection_table_name
    #content_type.constantize.table_name
    content_type.pluralize.underscore.to_sym if content_type
  end

  def admin_cached_key
    "admin-pages/#{Globalize.locale}/#{site.cache_key}/#{self.cached_key}"
  end
  protected

  # Apply restriction status to child section
  def set_restrictions_to_child_pages
    self.descendants.map do |c|
      c.update_attributes(:restricted => self.restricted?)
    end
  end

  # Apply restriction status regarding the parent restriction
  def inherit_restricted_status
    self.restricted = parent.restricted?
  end

  def update_path_and_save
    self.update_path
    self.save
  end

  def update_descendants_path
    return unless @path_dirty
    self.descendants.map do |c|
      c.update_path
      c.save
    end
    @path_dirty = false
  end

  def normalize_name
    self.name = self.title.clone if self.name.blank? && self.title.present?
    self.name.parameterize if self.name.present?
  end

  def normalize_slug
    unless self.need_slug?
      self.path = self.slug = ''
    else
      self.slug = self.title if (self.slug.blank? && self.title.present?)
      if (slug_changed? && self.slug.present?)
        if self.site.preferred_flat_slug
          self.slug = self.slug.split("/").map { |p| transliterate_slug(p) }.join("/")
        else
          self.slug = transliterate_slug(self.slug)
        end
      end
    end
    self.update_path if self.slug_changed? || self.parent_id_changed?
  end

  #def save_translations!
  #  update_path if self.path_changed?
  #  super
  #end

  # Clean up permalinks for no-latin languages
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

  def ensure_site_presence
    self.site_id = self.parent.site_id
  end
end
