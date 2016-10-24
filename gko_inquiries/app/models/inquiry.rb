class Inquiry < ActiveRecord::Base

  belongs_to_site

  ## virtual attributes for anti-spam ##
  attr_accessor :ghost, :receiver
  
  filters_spam :message_field => :message,
               :email_field => :email,
               :author_field => :name,
               :other_fields => [:phone],
               :extra_spam_words => %w(href= loans online casino sex sexe payday secured)


  attr_accessible(
    :type, 
    :confirmation_code, 
    :to_email, 
    :name, 
    :email, 
    :phone, 
    :message, 
    :open, 
    :options,
    :ghost,
    :receiver,
    :site_id)

  validates :name, :message, :presence => true
  validates :email, :presence => true, :email => true

  acts_as_indexed :fields => [:name, :email, :message, :phone]

  default_scope :order => 'created_at DESC'

  def self.previous(record, field = "created_at")
    in_site(record.site_id).where("inquiries.#{field} < ?", record.send(field)).order("inquiries.#{field} DESC")
  end

  def self.next(record, field = "created_at")
    in_site(record.site_id).where("inquiries.#{field} > ?", record.send(field)).order("inquiries.#{field} ASC")
  end

  def self.latest(number = 7, include_spam = false)
    include_spam ? limit(number) : ham.limit(number)
  end

  def self.with_email(email)
    where("#{self.class.table_name}.email like ?", "%#{email}%")
  end
  
  def self.with_name(name)
    where("#{self.class.table_name}.name like ?", "%#{name}%")
  end

  #before_validation do |r|
  #  r.message = strip_tags(message)
  #end

  def confirmed?
    !confirmation_code.nil?
  end

  def confirm!
    #self.confirmed_at = Time.zone.now if ( self.confirmed_at.nil? )
    self.confirmation_code = nil
    self.save!
  end

  def next(field = "created_at")
    self.class.next(self, field).first
  end

  def previous(field = "created_at")
    self.class.previous(self, field).first
  end
  
  # Ghost attribute must be blank 
  # This is a simple way to avoid spam and the input should be hidden with CSS.
  def human?
    self.ghost.blank?
  end

  #TODO Cleanup
  def set_default_values
    if Rails.env.development?
      self.email = "regis@joufdesign.com"
      self.message = "Thanks for the test you sent."
      self.name = "John Doe"
    end
  end

end
