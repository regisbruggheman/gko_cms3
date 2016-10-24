class TableInquiry < Inquiry

  has_option :person_count, :type => :integer, :default => 2
  has_option :service, :type => :string
  has_option :date, :type => :date
  validates :date, :presence => true
  validates :person_count, :presence => true
  validates :service, :presence => true

  #TODO Cleanup
  def set_default_values
    if Rails.env.development?
      self.to_email = "jftricot@joufdesign.com"
      self.email = "regis@joufdesign.com"
      self.message = "Thanks for the test you sent."
      self.name = "Regis Bruggheman"
    end
  end
end
