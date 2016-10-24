class Document < ActiveRecord::Base
  belongs_to_site
  
  # What is the max document size a user can upload
  MAX_SIZE_IN_MB = 5
  
  # What are the document formats a user can upload
  FILE_TYPES = %w(application/pdf)
  
  document_accessor :document
  
  translates :title, :alt 
  
  class Translation
    attr_accessible :locale
  end
  
  has_many :document_assignments, :dependent => :destroy

  attr_accessible :document, :title, :lang, :alt
  
  before_validation do |r|
    r.title = CGI::unescape(document_name.to_s).gsub(/\.\w+$/, '').titleize unless r.title.present?
  end

  validates :document, :presence => {},
            :length => {:maximum => MAX_SIZE_IN_MB.megabytes}

  validates_property :mime_type, :of => :document, :in => FILE_TYPES,
                     :message => :incorrect_document_type

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title, :document_name]

  delegate :size, :mime_type, :url, :name, :ext, :to => :document

  class << self

    def with_title(q)
      with_globalize(:title => q)
    end

    def with_document_name(q)
      where("documents.document_name LIKE ?", "%#{q}%")
    end

  end
end

