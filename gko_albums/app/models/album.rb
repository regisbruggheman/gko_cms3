class Album < Content
  default_scope :order => 'contents.position'
end
