require 'inherited_resources'
require 'has_scope'
class Admin::BaseController < InheritedResources::Base
  include Extensions::Controllers::Base
  include Extensions::Controllers::Permission

  helper 'admin/globalize', 'admin/gko_base', 'bootstrap', 'admin/images', 'images'
  helper_method :resources_controller?

  respond_to :html, :js
  layout :layout?

  before_filter :set_locale, :authorize_admin, :set_resource_locale
  after_filter :store_location?, :only => [:index] # for redirect_back_or_default
  before_filter :check_json_authenticity, :only => :index
  after_filter :reset_resource_locale

  # Used by WYMEditor to display dialog
  def wymiframe
    render :template => "/wymiframe", :layout => false
  end

  # Set locale to fr until admin translations was made
  def set_locale
    I18n.locale = session[:admin_locale] = 'fr'
  end

  def reset_resource_locale
    Globalize.locale = nil
  end

  def set_resource_locale
    Globalize.locale = if params[:action] =~ /^(new)$/
      current_site.default_locale
    elsif params[:cl].present?
      params[:cl].to_sym
    elsif session[:resource_locale]
      session[:resource_locale].to_sym
    else
      current_site.default_locale
    end
    params[:cl] = Globalize.locale.to_s if params[:cl].present?
    @resource_locale = session[:resource_locale] = Globalize.locale
  end

  def resources_controller?
    false
  end

  def admin?
    true # we're in the admin base controller, so always true.
  end

  protected

  # Index request for JSON needs to pass a CSRF token in order to prevent JSON Hijacking
  def check_json_authenticity
    return unless request.format.js? or request.format.json?
    return unless protect_against_forgery?
    return unless params[request_forgery_protection_token]
    auth_token = params[request_forgery_protection_token]
    unless (auth_token and form_authenticity_token == URI.unescape(auth_token))
      raise(ActionController::InvalidAuthenticityToken)
    end
  end

  def layout?
    #FIXME patch for user:changepassword. current_user seems to be nil
    if !user_signed_in?
      redirect_to new_session_path and return
    elsif request.xhr?
      false
    elsif from_dialog?
      "admin_dialog"
    else
      # current_site may be nil for account administration
      if current_site
        #FIXME Hack because overwritting layout? function in Store gem does not work
        current_site.has_plugin?(:store) ? "store_admin" : "admin"
      else
        "admin"
      end
    end
  end

  # Check whether it makes sense to return the user to the last page they
  # were at instead of the default e.g. admin_pages_path
  # right now we just want to snap back to index actions and definitely not to dialogues.
  def store_location?
    store_location unless request.xhr? || from_dialog?
  end
end
