class Project < Content 

  #has_one :video, :foreign_key => 'content_id', :dependent => :destroy
  #accepts_nested_attributes_for :video, :reject_if => :all_blank
  
  has_option :website, :type => :string

  default_scope :order => 'contents.position ASC'
  self.sortable = true

  def self.latest(count = 4)
    published.limit(count).with_globalize
  end

  preference :release_date, :string
  
  #attr_accessible :video_attributes, :preferred_release_date
  attr_accessible :preferred_release_date

end
