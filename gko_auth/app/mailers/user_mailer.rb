class UserMailer < ActionMailer::Base
  
  Gko::Core::MailSettings.init
  
  def reset_password_instructions(user)
    @user = user
    @edit_password_reset_url = edit_user_password_url(:host => Site.current.host, :reset_password_token => user.reset_password_token)
    
    #TODO Bug in url when using html template
    mail(:from => "\"#{Site.current.title}\" <#{self.smtp_settings[:mails_from]}>",
         :subject => t("devise.mailer.reset_password_instructions.subject"),
         :to => user.email)
  end

  def confirmation_instructions(user)
    @user = user
    mail(:from => "\"#{Site.current.title}\" <#{self.smtp_settings[:mails_from]}>",
         :subject => t("devise.mailer.confirmation_instructions.subject"),
         :to => user.email)
  end

  def unlock_instructions(user)
    @user = user
    mail(:from => "\"#{Site.current.title}\" <#{self.smtp_settings[:mails_from]}>",
         :subject => t("devise.mailer.unlock_instructions.subject"),
         :to => user.email)
  end

end
