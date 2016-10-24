module Extensions
  module Controllers
    module Cacheable

    extend ActiveSupport::Concern

    included do # Extend controller
      caches_action :index, 
                    :cache_path => :index_cache_path.to_proc, 
                    :if => :cache_action_index?
    end

    protected
    
    # Get the cache path for the index action including all parameters
    def index_cache_path
      timestamp = parent.collection_timestamp
      string = timestamp + params.inspect
      {:tag => Digest::MD5.hexdigest(string)}
    end
    
    # Check if index action is cached.
    # Do not cache json/js format else DOM is not modified by partial
    def cache_action_index?
      site.admin_cache_enabled && !(request.format.json? || request.format.js?)
    end

    end # Cacheable
  end # Models
end # Extensions
