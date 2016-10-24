Site.class_eval do
  has_many :hotel_inquiries, :dependent => :destroy
  has_many :table_inquiries, :dependent => :destroy
  has_option :hotel_inquiry_recipients, :default => "contact@joufdesign.com", :type => :string
  has_option :table_inquiry_recipients, :default => "contact@joufdesign.com", :type => :string

  before_validation do |r|
    #Remove all white space if any
    r.hotel_inquiry_recipients = r.hotel_inquiry_recipients.split(',').compact.collect { |x| x.gsub(/\s+/, "") }.join(',')
    r.table_inquiry_recipients = r.table_inquiry_recipients.split(',').compact.collect { |x| x.gsub(/\s+/, "") }.join(',')
  end
end