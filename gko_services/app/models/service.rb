class Service < Content
  default_scope :order => 'contents.position'
  has_option :price, :type => :string
  has_option :duration, :type => :string
end