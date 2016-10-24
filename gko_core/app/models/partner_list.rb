class PartnerList < Section

  include Extensions::Models::IsList
  has_many :partners, :foreign_key => 'section_id', :dependent => :destroy, :order => 'partners.title DESC'

  has_option :children_thumb_size, :default => "200x", :type => :string

  def content_type
    "Partner"
  end

end
