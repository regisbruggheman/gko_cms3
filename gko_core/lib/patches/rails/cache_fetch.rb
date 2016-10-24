# When using memcached, if you store Model objects in the cache, 
# when you go to load to object back out it doesn't know about
# your Model classes and throws an 'Undefined Class/Module' error.
# http://stackoverflow.com/questions/3531588/memcached-as-an-object-store-in-rails
Gem.patching('rails', '3.2.22') do
  Rails.cache.instance_eval do
    def fetch(key, options = {}, rescue_and_require=true)
      super(key, options)

    rescue ArgumentError => ex
      if rescue_and_require && /^undefined class\/module (.+?)$/ =~ ex.message
        self.class.const_missing($1)
        fetch(key, options, false)
      else
        raise ex
      end
    end
  end
end