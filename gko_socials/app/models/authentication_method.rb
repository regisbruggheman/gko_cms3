class AuthenticationMethod < ActiveRecord::Base
  attr_accessible :provider, :api_key, :api_secret, :environment, :active
  
  def self.active
    where(:environment => ::Rails.env, :active => true)
  end 
  
  def self.active_authentication_methods?
    found = false
    where(:environment => ::Rails.env).each do |method|
      if method.active
        found = true
      end
    end
    return found
  end

  scope :available_for, lambda { |user|
    sc = where(:environment => ::Rails.env)
    sc = sc.where(["provider NOT IN (?)", user.authentications.map(&:provider)]) if user and !user.authentications.empty?
    sc
  }
end
