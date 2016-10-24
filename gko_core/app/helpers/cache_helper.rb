module CacheHelper
  # Adds conditional caching
  def cache_if(condition, name = {}, &block)
    if condition &&
        cache(name, &block)
    else
      yield
    end

    nil
  end

  def resource_cache(record, &block)
    cache([request.format, device_type, controller_name, action_name, I18n.locale, site, record], &block)
  end

  def collection_row_cache(record, &block)
    cache([request.format, device_type, controller_name, action_name, I18n.locale, site, record], &block)
  end

  def collection_cache(&block)
    if @category
      cache([params[:page], request.format, device_type, controller_name, action_name, I18n.locale, site, parent, @category], &block)
    elsif @tag
      cache([params[:page], request.format, device_type, controller_name, action_name, I18n.locale, site, parent, @tag], &block)
    else
      cache([params[:page], request.format, device_type, controller_name, action_name, I18n.locale, site, parent], &block)
    end
  end

end
