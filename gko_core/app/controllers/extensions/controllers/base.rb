# Commun controller for backend and frontend
module Extensions
  module Controllers
    module Base

      extend ActiveSupport::Concern

      included do # Extend controller 
        
        helper_method :site,
          :current_site,
          :local_request?,
          :from_dialog?,
          :user_admin?,
          :user_master?,
          :admin?,
          :resources,
          :site_locales,
          :current_locale?

        helper :translation

        protect_from_forgery # See ActionController::RequestForgeryProtection

        send :before_filter, :current_site
        send :after_filter, :flash_to_headers

        #if Gko::Core.rescue_not_found
        #  send :rescue_from, ActiveRecord::RecordNotFound,
        #                     ::AbstractController::ActionNotFound,
        #                     ActionView::MissingTemplate,
        #                     :with => :error_404 
        #end
      end

      module ClassMethods

      end

      def site_locales
        current_site ? current_site.language_codes : [I18n.default_locale.to_sym]
      end

      def current_locale?(locale)
        locale && (locale.to_sym == I18n.locale.to_sym)
      end

      # Redirect to the URI stored by the most recent store_location call or
      # to the passed default.
      def redirect_back_or_default(default)
        redirect_to(session[:gko_return_to] || default)
        session[:gko_return_to] = nil
      end

      #FIXME do a better access
      def site
        @current_site ||= begin
          if admin? and (user_admin? || user_master?)
            if params.has_key?(:site_id)
              site = Site.find(params[:site_id].to_i)
            elsif controller_name == 'sites' and params[:action] =~ /^(edit|update)$/
              site = Site.includes([:languages, :translations]).find(params[:id].to_i)
            end
          end
          site ||= Site.includes([:languages, :translations]).by_host(request.host_with_port)
          raise "Site #{request.host_with_port} not found" unless site
          Site.current = site
          site
        end
      end
      alias :current_site :site

      def resources
        @resources ||= with_chain(resource).tap { |r| r.unshift(route_prefix) if route_prefix }.uniq.dup
      end

      def admin?
        #controller_path =~ %r{^admin/}
        %r{^admin/} === controller_name
      end

      def local_request?
        Rails.env.development? || /(::1)|(127.0.0.1)|((192.168).*)/ === request.remote_ip
      end

      def user_master?
        @user_master ||= (current_user && current_user.is_master?)
      end

      def user_admin?
        @user_admin ||= (current_user && current_user.is_admin?)
      end

      def from_dialog?
        @from_dialog ||= (params[:dialog] == 'true' or params[:modal] == 'true')
      end

      def error_404(exception=nil)
        # fallback to the default 404.html page.
        file = Rails.root.join 'public', '404.html'
        file = Gko.roots(:'Gko::Core').join('public', '404.html') unless file.exist?
        render :file => file.cleanpath.to_s.gsub(%r{#{file.extname}$}, ''),
               :layout => false, :status => 404, :formats => [:html]
        return false
      end

      protected
      
      # Needs to be overriden so that we use Gko's Ability rather than anyone else's.
      def current_ability
        @current_ability ||= Ability.new(current_user)
      end

      private

      def flash_to_headers
        if request.xhr?
          #avoiding XSS injections via flash
          flash_json = Hash[flash.map{|k,v| [k,ERB::Util.h(v)] }].to_json
          response.headers['X-Flash-Messages'] = flash_json
          flash.discard # don't want the flash to appear when you reload page
        end
      end

      # FIXME
      def route_prefix
        @route_prefix ||= self.class.resources_configuration[:self][:route_prefix].try(:to_sym)
      end

    end #Base
  end #Controllers
end #Extensions
