class Site < ActiveRecord::Base

  ## behaviours ##
  attr_accessible(
    :public,
    :front_page_cached,
    :host,
    :theme_id,
    :title,
    :page_types,
    :plugins,
    :meta_title,
    :timezone,
    :subtitle,
    :default_image,
    :remove_default_image,
    :stylesheet,
  :javascript)

  attr_accessible(
    :preferred_menu_level,
    :preferred_facebook_account,
    :preferred_primary_menu_style,
    :preferred_contact_email,
    :preferred_navigation_columns,
    :preferred_currency,
    :preferred_public_layout,
    :preferred_contact_address,
    :preferred_flat_slug,
    :preferred_typekit_key,
    :preferred_google_map_api_key,
    :preferred_display_contact_address,
  :preferred_homepage_cache_enabled)

  TRANSLATED_FIELD = [
    :title,
    :subtitle,
    :meta_title
  ].freeze

  translates *TRANSLATED_FIELD

  class Translation
    attr_accessible :locale
  end

  include Extensions::Models::Translatable

  image_accessor :default_image
  PRIMARY_MENU_STYLES = %w[dropdown tree slide flat]
  serialize :plugins, Array
  serialize :page_types, Array

  ## accessors ##

  class_attribute :multi_sites_enabled

  ## associations ##

  has_many :languages, :dependent => :destroy
  has_many :assets, :dependent => :destroy
  has_many :mail_methods, :dependent => :destroy
  has_many :homes
  has_many :sections, :inverse_of => :site
  has_many :pages
  has_many :faq_pages
  has_many :redirects
  has_many :partner_lists
  has_many :partners, :through => :partner_lists
  has_many :images, :dependent => :destroy
  has_many :image_folders, :inverse_of => :site, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :document_lists
  has_many :document_items, :through => :document_lists

  ## validations ##

  validates :title, :presence => true
  validates :host, :presence => true,
    :uniqueness => true,
    #:format => { :with => /^[a-z0-9_-]+$/ },
    :length => {:maximum => 100},
    :exclusion => {:in => Gko::Core.reserved_subdomains}

  ## options ##
  has_option :prelaunch, :type => :boolean, :default => false
  has_option :enable_mobile_layout, :type => :boolean, :default => false
  has_option :google_analytics_key, :type => :string
  has_option :google_webmaster_tools_key, :type => :string
  has_option :layout, :default => "application"
  has_option :drop_down_menu, :type => :boolean, :default => true
  has_option :display_images_in_background, :default => false, :type => :boolean
  has_option :include_theme_switcher, :default => true, :type => :boolean
  has_option :authenticity_token_on_frontend, :default => true, :type => :boolean
  has_option :include_alternate_links, :default => false, :type => :boolean
  #TODO : remove :mobile_cache_enabled
  # has_option :mobile_cache_enabled, :default => false, :type => :boolean
  #TODO : remove :copyright_name
  has_option :copyright_name, :type => :string
  has_option :site_title_on_all_pages, :default => true, :type => :boolean
  has_option :use_image_folders, :default => true, :type => :boolean
  has_option :images_author_enabled, :default => false, :type => :boolean

  # Active or deactivate the cache mechanism for the admin part
  has_option :admin_cache_enabled, :type => :boolean, :default => true
  has_option :slideshow, :default => "flexslider"
  # Indicate the style of the main menu
  preference :primary_menu_style, :string, :default => PRIMARY_MENU_STYLES[0]
  # Indicate if section slugs shuould include parents permalinks
  preference :flat_slug, :boolean, :default => false
  # Number of levels for the menu
  preference :menu_level, :integer, :default => 3
  # Number of columns for the primary menu
  preference :navigation_columns, :integer, :default => 1
  # Layout for the public application
  preference :public_layout, :string, :default => nil
  # Type kit key used by gko as default
  preference :typekit_key, :string, :default => nil
  # The default email adress
  preference :contact_email, :string, :default => nil
  # The default contact_address

  #TODO : remove :contact_address
  #preference :contact_address, :text, :default => nil
  #TODO : remove ::display_contact_address
  #preference :display_contact_address, :string, :default => 'header'
  # The facebook account to show the I Like Plugin
  preference :facebook_account, :string, :default => nil
  # The google map api (may be unuseful)
  preference :google_map_api_key, :string, :default => nil
  # The default currency (may be unuseful)
  preference :currency, :string, :default => '€'
  # Active or deactivate the cache mechanism
  preference :cache_enabled, :boolean, :default => false
  # Active or deactivate the cache for the homepage that can be dynamic
  preference :homepage_cache_enabled, :boolean, :default => true

  #TODO remove :global_slideshow
  # preference :global_slideshow, :boolean, :default => false
  #TODO remove :global_slideshow
  preference :image_grid_size, :string, :default => '312x208#'
  #TODO remove :global_slideshow
  #preference :image_thumb_size, :string, :default => '156x104#'
  #TODO remove :global_slideshow
  preference :image_carousel_size, :string, :default => '980x654#'

  attr_accessible :preferred_global_slideshow, :preferred_image_carousel_size, :preferred_image_grid_size, :preferred_image_thumb_size

  # Format classique appareil photo 2/3
  # 1300x867
  # 1200x800
  # 1080x720
  # 1000x667
  # css foundation full-width 980x654
  # 900x600
  # 800x533
  # 700x467
  # 600x400
  # 620x413
  # css foundation 3 columns full-width 312x208
  # 280x187
  # 110x73
  def image_sizes
    {   :small => 'x110',
        :medium => 'x208',
        :large => 'x413',
        :big => 'x654',
        :storage => 'x867'
        }
  end

  ## callbacks ##

  before_create :create_default_languages
  before_create :create_default_pages
  before_destroy :destroy_pages
  before_validation :normalize_host, :if => proc { host.present? }
  before_save :strip_plugins, :if => proc { plugins.present? }
  before_save :strip_page_types, :if => proc { page_types.present? }

  ## class methods ##

  self.multi_sites_enabled = false

  def self.by_host(host)
    r = Site.count == 1 ? Site.first : Site.find_by_host(host)
    return r if r
    segments = host.split(".")
    if Rails.env.development? && segments.pop == "local"
      segments.push('com')
      r = Site.find_by_host(segments.join('.'))
      return r if r
    end
  end

  def self.current
    Thread.current[:site]
  end

  def self.current=(site)
    Thread.current[:site] = site
  end

  ## instance methods ##

  def home
    self.sections.root
  end

  def multi_sites_enabled?
    self.class.multi_sites_enabled
  end

  def plugins
    read_attribute(:plugins) || []
  end

  def has_plugin?(name)
    Gko.engine_names.include?(name.to_sym) and self.plugins.include?(name.to_s)
  end

  def page_types
    read_attribute(:page_types) || []
  end

  def has_page_type?(name)
    self.page_types.include?(name.to_s.downcase)
  end

  # Return the file system path where cached pages are stored
  def cache_path
    @cache_path ||= File.join("", "gko", "cache", "#{self.host}")
  end

  def cached_image_folders
    timestamp = Digest::MD5.hexdigest "image_folders-#{self.image_folders.maximum(:updated_at)}.try(:to_i)-#{self.image_folders.count}"
    Rails.cache.fetch [Globalize.locale, "admin", self, timestamp].join('/') do
      self.image_folders.nested_set.all
    end
  end

  def language_codes
    @language_codes ||= self.languages.all_codes
  end

  def cached_languages_all
    Rails.cache.fetch("admin-languages-#{Globalize.locale}-#{self.languages_count}-#{self.cache_key}") do
      self.languages.all
    end
  end

  # Return the all visibles locales by end-user
  def available_locales
    @available_locales ||= self.languages.published
  end

  def frontend_translated?
    @frontend_translated ||= (available_locales.count > 1)
  end

  # Return the default locale for this site
  # Default language cannot be unpublished
  def default_locale
    @default_locale ||= self.languages.get_default.code.to_sym
  end

  # TODO : Use by admin but should be removed
  def localized?
    @localized ||= (self.languages_count > 1)
  end

  def primary_menu
    @primary_menu ||= self.sections.root.children.in_menu.with_globalize
  end

  def admin_sections(conditions={})
    timestamp = Digest::MD5.hexdigest ["admin-pages", conditions.to_query, self.id, self.sections_cache_key].join('/')
    Rails.cache.fetch("#{Globalize.locale}-#{timestamp}") do
      self.sections.includes(:translations).arrange
      #self.sections.roots.nested_set.includes(:translations)
    end
  end

  def collection_timestamp(collection_name)
    "#{self.send(self.collection_name).maximum(:updated_at).try(:to_i)}-#{self.send(self.collection_name).count}" if self.respond_to?(collection_name)
  end

  def cached_live_sections(conditions={})
    timestamp = Digest::MD5.hexdigest ["live-sections", conditions.to_query, self.id, self.sections_cache_key].join('/')
    Rails.cache.fetch("#{Globalize.locale}-#{timestamp}") do
      self.sections.live(conditions).all
    end
  end

  def sections_cache_key
    "#{self.sections.maximum(:updated_at)}.try(:to_i)---#{self.sections.count}"
  end

  protected

  def strip_plugins
    self.plugins = self.plugins.compact.reject { |s| s.strip.empty? }
  end

  def strip_page_types
    self.page_types = self.page_types.compact.reject { |s| s.strip.empty? }
  end

  def normalize_host
    self.host = self.host.downcase
  end

  def destroy_pages
    # sections is a tree so we just need to delete all roots
    self.sections.roots.map(&:destroy)
  end

  private

  def create_default_languages
    languages.build(:code => I18n.default_locale.to_s, :public => true, :default => true)
  end

  def create_default_pages
    sections.build(:title => "Menu principal", :name => "primary_menu", :deletable => false, :type => "Page")
  end
end
