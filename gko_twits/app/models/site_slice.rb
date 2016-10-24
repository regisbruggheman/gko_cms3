Site.class_eval do
  has_many :twit_lists
  has_many :twits, :through => :twit_lists
end
