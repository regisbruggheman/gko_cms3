#require 'devise'
class User < ActiveRecord::Base

  devise :database_authenticatable, :token_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible(:email, :password, :password_confirmation, :remember_me, 
  :persistence_token, :role_ids, :username, :firstname, :lastname, 
  :preferred_language, :confirmed_at, :login, :site, :site_id)

  #serialize :roles, Array
  has_and_belongs_to_many :roles
  accepts_nested_attributes_for :roles
  belongs_to :site, :inverse_of => :users, :touch => true
  validates :site_id, :presence => true

  before_save :check_master
  before_validation :set_login

  # TODO: Restore User validation
  validates :email, :presence => true #, :uniqueness => true

  default_scope order('users.created_at DESC')

  class << self
    def with_email(q)
      where("users.email LIKE ?", "%#{q}%")
    end

    def with_role(role)
      includes(:roles).where("roles.name" => role.to_s.downcase)
    end

    def superadmin
      with_role("master")
    end

    def master
      with_role("master")
    end

    def admin
      with_role("admin")
    end

    def master_created?
      User.master.count > 0
    end
  end

  def send_reset_password_instructions
    generate_reset_password_token!
    UserMailer.reset_password_instructions(self).deliver
  end
  
  def add_role(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Role)
    roles << Role[title] unless has_role?(title)
  end

  def has_role?(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(Role)
    roles.any? { |role| role.name == title.to_s } 
  end

  def is?(title)
    has_role?(title)
  end

  def is_master?
    has_role?("master")
  end

  def is_admin?
    has_role?("admin")
  end

  def is_member?
    has_role?("member")
  end

  def can_delete?(user_to_delete = self)
    user_to_delete.persisted? and
      !user_to_delete.is_master? and
      User.count > 1 and
      id != user_to_delete.id
  end
  
  def create_first
     if valid?
       # first we need to save user
       save
       # add gko role
       add_role(:admin)
       # add superuser role if there are no other users
       add_role(:master) if Role[:admin].users.count == 1
     end

     # return true/false based on validations
     valid?
   end

  protected

  def password_required?
    !persisted? || !password.blank? || !password_confirmation.blank?
  end

  private

  def check_master
    return if self.class.master_created?
    master_role = Role.find_or_create_by_name "master"
    self.roles << master_role
  end

  def set_login
    # for now force login to be same as email, eventually we will make this configurable, etc.
    self.login ||= self.email if self.email
  end

  # Generate a friendly string randomically to be used as token.
  def self.friendly_token
    SecureRandom.hex(15)#.tr('+/=', '-_ ').strip.delete("\n")
  end

  # Generate a token by looping and ensuring does not already exist.
  def self.generate_token(column)
    loop do
      token = friendly_token
      break token unless find(:first, :conditions => {column => token})
    end
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

end
