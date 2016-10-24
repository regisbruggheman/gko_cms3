require 'digest/sha1'

class ContentsController < BaseController
  include Extensions::Controllers::BelongsToSection

  caches_action :index, 
                :cache_path => :index_cache_path.to_proc, 
                :if => :cache_action_index?

  # Disabled for now because of this action kills the cache
  # after_filter :increment_access_count, :only => [:show ]

  # Save whole Page after delivery
  after_filter { |c| c.write_cache? }

  protected

  def increment_access_count
    resource.increment!(:access_count, 1)
  end

  private
  
  # Get the cache path for the index action including all parameters, locale
  def index_cache_path
    timestamp = parent.collection_timestamp
    string = I18n.locale.to_s + request.format + Digest::MD5.hexdigest(timestamp + params.inspect)
    {:tag => string}
  end
  
  # Do not cache json/js format else DOM is not modified by partial
  def cache_action_index?
    Rails.env.production? && site.public && !(request.format.json? || request.format.js?)
  end
end