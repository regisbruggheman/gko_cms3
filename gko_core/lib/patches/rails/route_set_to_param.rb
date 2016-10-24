# make route_set generator pass the current segment/param name to to_param
# if arity allows it. so we can use param names in routes and distinguish them
# in the model.
require 'gem-patching'
Gem.patching('rails', '3.2.22') do
  require 'action_dispatch/routing/route_set'

  ActionDispatch::Routing::RouteSet::Generator.class_eval do

    #PARAMETERIZE_ALT = {
    #  :parameterize => lambda do |name, value|

    #   if name == :controller
    #     value
    #   elsif value.is_a?(Array)
    #     value.map do |v|
    #       Rack::Mount::Utils.escape_uri(value.method(:to_param).arity == 0 ? value.to_param : value.to_param(name))
    #     end.join('/')
    #   else
    #     if value.method(:to_param).arity == 0
    #       return nil unless param = value.to_param
    #     else
    #       return nil unless param = value.to_param(name)
    #     end
    #     param.split('/').map { |v| Rack::Mount::Utils.escape_uri(v) }.join("/")
    #  end
    # end
    #}
    PARAMETERIZE_ALT = lambda do |name, value|
      if name == :controller
        value
      elsif value.is_a?(Array)
        Rack::Mount::Utils.escape_uri(value.method(:to_param).arity == 0 ? value.to_param : value.to_param(name))
      else
        if value.method(:to_param).arity == 0
          return nil unless param = value.to_param
        else
          return nil unless param = value.to_param(name)
        end
        param.split('/').map { |v| Rack::Mount::Utils.escape_uri(v) }.join("/")
      end
    end

    #def generate
    #  path, params = @set.set.generate(:path_info, named_route, options, recall, PARAMETERIZE_ALT)
    #p "Generator generate path: #{path.to_s}"
    # raise_routing_error unless path
    # return [path, params.keys] if @extras
    # [path, params]
    #rescue Rack::Mount::RoutingError
    #  raise_routing_error
    #end

    def generate
      path, params = @set.formatter.generate(:path_info, named_route, options, recall, PARAMETERIZE_ALT)
      params ||= {}
      #p "XXXX generate path #{path} params #{params}"
      raise_routing_error unless path

      return [path, params.keys] if @extras

      [path, params]
    rescue Journey::Router::RoutingError
      raise_routing_error
    end


  end
end