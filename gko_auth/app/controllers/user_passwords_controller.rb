class UserPasswordsController < Devise::PasswordsController
  include Extensions::Controllers::Base
  include Extensions::Controllers::Localize

  layout "auth"

  protected

  # FIXME Overwritte locale to default_locale otherwise
  # we may have an error if 'fr' is not used by the appplication.
  # Set locale to fr until admin translations was made
  def set_locale
    I18n.locale = session[:admin_locale] = 'fr'
  end

  # Override Device the path used after sending reset password instructions
  # seems to generate bad url => /session/new.user
  def after_sending_reset_password_instructions_path_for(resource_name)
    login_path
  end
end
