Section.class_eval do
  has_option :commentable, :default => false, :type => :boolean
  has_option :moderate_comments, :default => true, :type => :boolean
end