Content.class_eval do
  has_many :comments, :as => :commentable, :dependent => :destroy
  accepts_nested_attributes_for :comments
  ## fields ##
  attr_accessible(
    :comment_attributes)
end
