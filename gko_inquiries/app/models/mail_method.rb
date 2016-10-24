class MailMethod < ActiveRecord::Base

    MAIL_AUTH = ['none', 'plain', 'login', 'cram_md5']
    SECURE_CONNECTION_TYPES = ['None','SSL','TLS']

    ## Associations ##
    belongs_to_site(
      :touch => true
    )
    
    ## validations ##
    validates :site_id,
              :presence => true
    validates :smtp_username,
              :presence => true
    validates :smtp_password,
              :presence => true
    validates :mails_from,
              :presence => true
    validates :environment,
              :presence => true               


    attr_accessible :site_id, :environment, :enable_mail_delivery,
                    :mails_from, :mail_bcc, :mail_domain,
                    :mail_host, :mail_port, :secure_connection_type, 
                    :mail_auth_type, :smtp_username, :smtp_password
          
    def self.current
      MailMethod.count == 1 ? MailMethod.first : where(:site_id => Site.current.id, :environment => Rails.env).first
    end
end
