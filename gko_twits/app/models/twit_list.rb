class TwitList < Section
  include Extensions::Models::IsList
  has_many :twits, :foreign_key => 'section_id', :dependent => :destroy, :order => 'twits.published_at DESC'

  accepts_nested_attributes_for :twits

  def content_type
    "Twit"
  end
end