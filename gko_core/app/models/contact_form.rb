class ContactForm < MailForm::Base
  attributes :civility, :validate => true
  attributes :lastname, :validate => true
  attributes :firstname, :validate => true
  attributes :email
  attributes :phone
  attributes :country
  attributes :company
  attributes :professional
  attributes :message
  attributes :nickname, :captcha => true
  
  validates :email, :presence => true, :email => true
  
  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Contact from website",
      :to => Site.current.preferred_contact_email,
      :from => %("#{lastname}" <#{email}>)
    }
  end
  
end