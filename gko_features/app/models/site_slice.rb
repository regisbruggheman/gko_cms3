Site.class_eval do
  has_many :features, :dependent => :destroy
  has_option :carousel_interval, :type => :integer, :default => 8
  preference :features_image_size, :string, :default => '980x300#'
  attr_accessible :preferred_features_image_size
  
  def live_features
    
  end
end