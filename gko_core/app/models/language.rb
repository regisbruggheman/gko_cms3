class Language < ActiveRecord::Base
  
  ## Extensions ##
  acts_as_list :scope => [:site_id]
  
  ## Associations ##
  belongs_to_site(
    :touch => true,
    :counter_cache => true
  )

  
  attr_accessible(
      :name,
      :code,
      :presentation,
      :public,
      :default,
      :site_id
    )
    validates :name, :presence => true,
              :uniqueness => {:scope => [:site_id], :case_sensitive => false}
    validates :code, :presence => true,
              :uniqueness => {:scope => [:site_id], :case_sensitive => false}
    validates :presentation, :presence => true,
              :uniqueness => {:scope => [:site_id], :case_sensitive => false}
    validate :presence_of_default_language, :if => proc { site_id.present? }
    validate :publicity_of_default_language
    validates_format_of :code, :with => /^[a-z]{2}$/, :if => proc { code.present? }
    
    before_validation :set_default_values_on_create, :on => :create, :if => "code.present?"
    before_destroy :check_for_default_before_destroy
    before_save :remove_old_default_before_save, :if => proc { |m| m.default_changed? && m != m.class.get_default_for_site(m.site) }
    after_save :move_to_first_position_after_save, :if => proc { |m| m.default_changed? && m = m.class.get_default_for_site(m.site) }
    
    default_scope :order => 'languages.position'
    
    class << self
      
      def published
        where(:public => true)
      end
      
      def all_codes
        pluck(:code)
      end

      def all_codes_for_published
        published.collect(&:code)
      rescue
        []
      end
      
      def not_default
        where(:default => false)
      end

      def get_default
        find_by_default(true)
      end
      
      def get_default_for_site(site)
        find_by_site_id_and_default(site.id, true)
      end
      
    end #self


    private

    ## validations ##
    def presence_of_default_language
      if self.class.get_default_for_site(self.site) == self && self.default_changed?
        errors.add(:base, I18n.t("We need at least one default."))
        return false
      else
        return true
      end
    end

    def publicity_of_default_language
      if self.default? && !self.public?
        errors.add(:base, I18n.t("Default language has to be public"))
        return false
      else
        return true
      end
    end

    ## callbacks ##
    def move_to_first_position_after_save
      move_to_top
    end
    
    def set_default_values_on_create
      t = I18n.t("locales.long.#{self.code}")
      self.name = t unless self.name.presence
      self.presentation = t unless self.presentation.presence
    end

    def remove_old_default_before_save
      lang = self.class.get_default_for_site(self.site)
      return true if lang.nil?
      lang.default = false
      lang.save(:validate => false)
    end

    def check_for_default_before_destroy
      if self.default?
         errors.add(:base, "Default language is not deletable")
         false
      end
    end

  end
