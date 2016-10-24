Site.class_eval do
  has_many :categories, :foreign_key => :site_id
end
