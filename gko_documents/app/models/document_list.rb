class DocumentList < Section
  include Extensions::Models::IsList
  has_many :document_items, :foreign_key => 'section_id', :dependent => :destroy

  ## options ##
  has_option :use_country, :default => false, :type => :boolean
  has_option :use_publication_date, :default => false, :type => :boolean
  has_option :thumbs_size, :default => 'x110', :type => :string
  has_option :use_description, :default => false, :type => :boolean
  
  def content_type
    "DocumentItem"
  end

  before_save do |r|
    r.template = 'files' unless r.template.present?
  end

end
