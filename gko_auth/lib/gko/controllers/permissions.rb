require 'action_controller'

module Gko
  module Controllers
    module Permissions
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        def has_permissions
          include Gko::Controllers::Permissions::InstanceMethods

          prepend_before_filter :set_current_user
          helper_method :current_user


          # graceful error handling for cancan authorization exceptions
          rescue_from CanCan::AccessDenied do |exception|
            return unauthorized
          end
        end
      end

      module InstanceMethods

        private

        def authorize_admin
          begin
            model = controller_name.classify.constantize
          rescue
            model = Object
          end
          #authorize! :admin, model
          authorize! params[:action].to_sym, model
        end

        # Redirect as appropriate when an access request fails.  
        # The default action is to redirect to the login screen.
        # Override this method in your controllers if you want 
        # to have special behavior in case the user is not authorized
        # to access the requested action.  
        # For example, a popup window might simply close itself.
        def unauthorized
          respond_to do |format|
            format.html do
              if admin?
                flash.now[:error] = I18n.t(:authorization_failure)
                redirect_to login_path and return
              elsif current_user || admin?
                flash.now[:error] = I18n.t(:authorization_failure)
                render 'shared/unauthorized'
                #FIXME:: Should be that
                #render 'shared/unauthorized', :layout => 'layouts/application', :status => 401
              else
                store_location
                redirect_to login_path and return
              end
            end
            format.xml do
              request_http_basic_authentication 'Web Password'
            end
            format.json do
              render :text => "Not Authorized \n", :status => 401
            end
          end
        end

        def store_location
          # disallow return to login, logout, signup pages
          disallowed_urls = [signup_url, login_url, destroy_user_session_path]
          disallowed_urls.map! { |url| url[/\/\w+$/] }
          unless disallowed_urls.include?(request.fullpath)
            session["user_return_to"] = request.fullpath
          end
        end

        def set_current_user
          User.current = current_user
        end
      end
    end
  end
end
ActionController::Base.send :include, Gko::Controllers::Permissions
