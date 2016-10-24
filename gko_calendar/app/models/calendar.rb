class Calendar < Section
  include Extensions::Models::IsList
  has_many :events, :foreign_key => 'section_id', :dependent => :destroy, :order => 'events.start_date DESC'

  def content_type
    "Event"
  end
end
