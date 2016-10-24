class Role < ActiveRecord::Base
  
  attr_accessible :name
  
  has_and_belongs_to_many :users
  
  before_validation :normalize_name, :if => proc { name.present? }
  validates :name, :presence => true, :uniqueness => true

  def normalize_name(role_name = self.name)
    self.name = role_name.to_s.downcase
  end

  def self.[](name)
    find_or_create_by_name(name.to_s.downcase)
  end
end