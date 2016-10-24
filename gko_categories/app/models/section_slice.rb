Section.class_eval do
  has_many :categories,
           :dependent => :destroy,
           :foreign_key => :section_id
  accepts_nested_attributes_for :categories
  attr_accessible :categories_attributes
  has_option :accept_categories, :default => false, :type => :boolean
  #TODOD has_option :include_categories_in_menu, :default => false, :type => :boolean
  
      
  def categorization_cached_key
    Digest::MD5.hexdigest("categorizations-#{self.categories.maximum(:updated_at)}.try(:to_i)-#{self.categories.count}")
  end
  
  def self.categories_in_use
    categories.includes(:categorizations).live.all.reject{|c| c.categorizations.empty?}
    #City.includes(:photos).where( :photos => {:city_id=>nil} )
  end
  
  # Get all categories tree for this section
  #def all_categories
  #  Rails.cache.fetch("#{::Globalize.locale.to_s}-#{categorization_cached_key}") do
  #    self.categories.arrange
  #  end
  #end
  
  # Get all LIVE categories tree for this section
  #def live_categories
  #  Rails.cache.fetch("#{::Globalize.locale.to_s}-#{categorization_cached_key}") do
  #    self.categories.live.arrange
  #  end
  #end
  
end