class TextElement < ActiveRecord::Base
  
  VALUE_TYPES = [ 
    :string,
    :html
  ].freeze
  
  TRANSLATED_FIELD = [
    :value
  ].freeze

  translates *TRANSLATED_FIELD

  class Translation
    attr_accessible :locale
  end

  default_scope :order => 'text_elements.position'
  acts_as_list :scope => [:section_id]

  belongs_to :section, :inverse_of => :text_elements, :touch => true
  attr_accessible :section_id, :key, :value, :value_type, :position

  validates :key, :presence => true
  validates :value_type, :presence => true
  
  def value_type
    read_attribute(:value_type) || 'html'
  end

end
