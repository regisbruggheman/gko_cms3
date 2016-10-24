Site.class_eval do
  has_many :users, :dependent => :destroy, :inverse_of => :site
end