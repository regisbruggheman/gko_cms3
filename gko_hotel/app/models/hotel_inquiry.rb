class HotelInquiry < Inquiry

  has_option :person_count, :type => :integer, :default => 2
  has_option :start_date, :type => :date
  has_option :end_date, :type => :date
  has_option :newsletter_registration, :type => :boolean, :default => false

  
  #TODO Cleanup
  def set_default_values
    if Rails.env.development?
      self.to_email = "jftricot@joufdesign.com"
      self.email = "regis@joufdesign.com"
      self.message = "Thanks for the test you sent."
      self.name = "Regis Bruggheman"
      self.start_date = Date.today + 14
      self.end_date = Date.today + 21
    end
  end
end
