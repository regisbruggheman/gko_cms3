class Comment < ActiveRecord::Base

  attr_accessible :name, :email, :body, :commentable_type, :commentable_id

  filters_spam :author_field => :name,
               :email_field => :email,
               :message_field => :body

  belongs_to :commentable, :polymorphic => true

  acts_as_indexed :fields => [:name, :email, :body]

  #----- Validations -----------------------------------------------------------
  #before_validation do |r|
  #  r.site_id = r.section.site_id if r.section.present?
  #end

  #before_create do |r|
  #  unless r.section.enabled?
  #    r.state = r.ham? ? 'approved' : 'rejected'
  #  end
  #end

  validates :commentable, :presence => true
  validates :name, :body, :presence => true
  validates :email, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  scope :unmoderated, :conditions => {:state => nil}
  scope :approved, :conditions => {:state => 'approved'}
  scope :rejected, :conditions => {:state => 'rejected'}

  def approve!
    self.update_attribute(:state, 'approved')
  end

  def reject!
    self.update_attribute(:state, 'rejected')
  end

  def rejected?
    self.state == 'rejected'
  end

  def approved?
    self.state == 'approved'
  end

  def unmoderated?
    self.state.nil?
  end

end
