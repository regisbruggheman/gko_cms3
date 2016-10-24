Site.class_eval do
  has_many :inquiries, :dependent => :destroy
  has_option :inquiry_recipients, :default => "contact@joufdesign.com", :type => :string
  has_option :inquiry_save_in_database, :default => true, :type => :boolean

  before_validation do |r|
    #Remove all white space if any
    r.inquiry_recipients = r.inquiry_recipients.split(',').compact.collect { |x| x.gsub(/\s+/, "") }.join(',')
  end

end
