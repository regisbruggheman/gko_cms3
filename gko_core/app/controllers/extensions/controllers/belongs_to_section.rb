module Extensions
  module Controllers
    module BelongsToSection

      extend ActiveSupport::Concern

      included do # Extend controller

        send :before_filter, :find_parent, :only => [:show, :index]
        send :before_filter, :find_resource, :only => [:show]

        include Extensions::Controllers::Seo

        helper_method :resource_has_stickers?,
          :resource_has_categories?,
          :parent_has_stickers?,
          :parent_has_categories?

        send :before_filter, :load_parent_categories, :only => [:show, :index]
        send :before_filter, :load_parent_stickers, :only => [:show, :index]
        send :before_filter, :load_resource_stickers, :only => [:show]
        send :before_filter, :load_resource_categories, :only => [:show]
        send :before_filter, :load_resource_associations, :only => [:show]

        #self.includes += [:categories, :stickers]
      end

      def index
        if parent.restricted? and !user_signed_in?
          @restricted_page_title = parent.title
          session["user_return_to"] = request.fullpath
          index!(:template => "pages/login")
        else
          index!
        end
      end

      def resource_has_stickers?
        parent_has_stickers? && load_resource_stickers.try(:any?)
      end

      def resource_has_categories?
        parent_has_categories? && load_resource_categories.try(:any?)
      end

      def parent_has_stickers?
        load_parent_stickers.try(:any?)
      end

      def parent_has_categories?
        load_parent_categories.try(:any?)
      end



      def find_parent
        @section = parent || error_404
      end

      def find_resource
        if params[:permalink].present?
          permalink = params[:permalink].split('/')
          begin
            c = end_of_association_chain.live.by_permalink(*permalink).first
          rescue
            error_404
          end
        elsif params[:id].present?
          begin
            c = end_of_association_chain.live.find(params[:id])
          rescue
            error_404
          end
        end
        set_resource_ivar(c)
      end

      protected

      def collection
        get_collection_ivar || begin
          c = load_resources
          c = filter_collection(c)
          c = search_all(c) if searching?
          c = order_all(c)
          c = paginate_all(c)
          set_collection_ivar(c)
        end
        #get_collection_ivar
      end
      
      def load_resource_associations
        @images = resource.images
        load_resource_categories
        load_resource_stickers

        if parent.commentable?
          @comments = resource.comments
          @comment = resource.comments.new
          if user_signed_in?
            @comment.name = current_user.username
            @comment.email = current_user.email
          end
        end
      end

      # TODO should be in category engine
      def load_resource_categories
        @resource_categories ||= parent.categorizable? ? resource.categories.translated : []
      end

      # TODO should be in sticker engine
      def load_resource_stickers
        @resource_stickers ||= resource.stickers.translated if parent.stickable?
      end

      # TODO should be in category engine
      def load_parent_categories
        @parent_categories ||= begin
          Rails.cache.fetch([I18n.locale, parent, parent.categorization_cached_key]) do
            parent.categories.translated.all
            #parent.categories.nested_set.arrange
          end if parent.categorizable?
        end
      end

      # TODO should be in sticker engine
      def load_parent_stickers
        @parent_stickers ||= begin
          Rails.cache.fetch([I18n.locale, parent, parent.sticking_cached_key]) do
            parent.stickers.translated.all
          end if parent.stickable?
        end
      end

          
      def load_resources
        end_of_association_chain.published.includes(self.includes).with_globalize
      end

      # Override this methods in sub-controller if needed
      def filter_collection(c)
        if params[:category_id].present? && @category = parent.categories.translated.find(params[:category_id])
          category_ids = @category.self_and_descendants.pluck(:id)
          c = c.categorized(category_ids)
        end

        if params[:sticker_id].present? && @sticker = parent.stickers.translated.find(params[:sticker_id])
          c = c.sticked(@sticker)
        end

        return c
      end

      def search_all(c)
        apply_scopes(c, params[:search])
      end

      def order_all(c)
        ordering? ? c.order(params[:search][:order]) : c
      end

      def paginate_all(c)
        c.paginate(:page => params[:page] || 1, :per_page => parent.contents_per_page) if c
      end

      def paging?
        @paging ||= searching? && params[:search].has_key?(:per_page)
      end

      def ordering?
        @ordering ||= searching? && params[:search].has_key?(:order)
      end

      def searching?
        @searching ||= params.has_key?(:search)
      end

      def cache_url
        if action_name == 'show'
          return resource.public_url
        elsif action_name == 'index'
          if @category
            return @category.public_url
          elsif @sticker
            return @sticker.public_url
          else
            return parent.public_url
          end
        end
      end
    end
  end
end
