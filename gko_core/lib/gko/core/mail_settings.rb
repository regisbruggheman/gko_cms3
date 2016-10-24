module Gko
  module Core
    module MailSettings

      # Override the Rails application mail settings based on preference.
      # This makes it possible to configure the mail settings
      # through an admin interface instead of requiring changes to the Rails environment file.
      def self.init
        #Rails.logger.warn "NOTICE: MailSettings"
        return unless mail_method = MailMethod.current
        ActionMailer::Base.default_url_options[:host] = mail_method.site.host
        if mail_method.enable_mail_delivery?
          mail_server_settings = {
            :address => mail_method.mail_host,
            :domain => mail_method.mail_domain,
            :port => mail_method.mail_port,
            :authentication => mail_method.mail_auth_type
          }

          if mail_method.mail_auth_type != 'none'
            mail_server_settings[:user_name] = mail_method.smtp_username
            mail_server_settings[:password] = mail_method.smtp_password
          end

          tls = mail_method.secure_connection_type == 'TLS'
          mail_server_settings[:enable_starttls_auto] = tls

          ActionMailer::Base.smtp_settings = mail_server_settings
          ActionMailer::Base.perform_deliveries = true
        else
          #logger.warn "NOTICE: Mail not enabled"
          ActionMailer::Base.perform_deliveries = false
        end
      end

    end
  end
end
