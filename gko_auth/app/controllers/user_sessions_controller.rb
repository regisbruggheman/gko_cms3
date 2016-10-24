require 'devise'
class UserSessionsController < Devise::SessionsController
  include Extensions::Controllers::Base
  include Extensions::Controllers::Localize

  layout "auth"

  # GET /resource/sign_in
  def new
    super
  end

  def create
    authenticate_user!
    if user_signed_in?
      respond_to do |format|
        format.html {
          flash.notice = t(:logged_in_succesfully)
          path = if !current_site.public
                    root_path
                 elsif current_user.is_master?
                   admin_root_path
                 elsif current_user.is_admin?
                   admin_root_path
                 elsif current_user.is_member?
                   admin_root_path
                 else
                   session[:user_return_to]
                 end
          
          redirect_back_or_default(path)
        }
      end
    else
      flash[:failure] = I18n.t("devise.failure.invalid")
      render :new
    end
  end

  def destroy
    cookies.clear
    session.clear
    super
  end

  protected

  def after_sign_out_path_for(resource_or_scope)
    root_path(:locale => I18n.default_locale)
  end

  # FIXME Overwritte locale to default_locale otherwise
  # we may have an error if 'fr' is not used by the appplication.
  # Set locale to fr until admin translations was made
  def set_locale
    I18n.locale = session[:admin_locale] = 'fr'
  end
end
