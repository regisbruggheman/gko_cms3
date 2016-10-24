require 'highline/import'

# see last line where we create an master if there is none, asking for email and password
def prompt_for_master_password
  if ENV['ADMIN_PASSWORD']
    password = ENV['ADMIN_PASSWORD'].dup
    say "Admin User Password #{password}"
  else
    password = ask('Password [master123]: ') do |q|
      q.echo = false
      q.validate = /^(|.{6,40})$/
      q.responses[:not_valid] = 'Invalid password. Must be at least 6 characters long.'
      q.whitespace = :strip
    end
    password = 'master123' if password.blank?
  end

  password
end

def prompt_for_master_email
  if ENV['ADMIN_EMAIL']
    email = ENV['ADMIN_EMAIL'].dup
    say "Admin User Email #{email}"
  else
    email = ask('Email [regis@joufdesign.com]: ') do |q|
      q.echo = true
      q.whitespace = :strip
    end
    email = 'regis@joufdesign.com' if email.blank?
  end

  email
end

def prompt_for_username
  if ENV['ADMIN_USERNAME']
    username = ENV['ADMIN_USERNAME'].dup
    say "Admin Username #{username}"
  else
    username = ask('Username [regis]: ') do |q|
      q.echo = true
      q.whitespace = :strip
    end
    username = 'regis' if username.blank?
  end

  username
end
def create_master_user
  if ENV['AUTO_ACCEPT']
    username = "Regis"
    password = "master123"
    email = "regis@joufdesign.com"
  else
    puts 'Create the master user (press enter for defaults).'
    username = prompt_for_username unless username
    email = prompt_for_master_email
    password = prompt_for_master_password
  end
  attributes = {
      :username => username,
      :password => password,
      :password_confirmation => password,
      :email => email
  }

  load 'user.rb'
  
  master = Site.first.users.build(attributes)
  if master.create_first
    puts "Master user has been created."
  end
end

if Site.first.users.empty?
  create_master_user
else
  puts 'Master user has already been previously created.'
end

