Site.class_eval do
  has_many :service_lists
  has_many :services, :through => :service_lists
end