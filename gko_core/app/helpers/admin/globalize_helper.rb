module Admin::GlobalizeHelper
  def glinks_to_actions(actions, *args)
    actions.map { |action| capture { send(:"glink_to_#{action}", *args) } }.join.html_safe
  end

  [:index, :new, :show, :edit, :destroy].each do |action|
    define_method(:"glink_to_#{action}") do |*args|
      options = args.extract_options!
      options[:class] = [action, options[:class]].compact.join(' ')
      scope = options.key?(:scope) ? options.delete(:scope) : 'actions'

      if action == :destroy
        model = args.last.class.respond_to?(:model_name) ? args.last : controller.resource
        name = model.class.model_name.human
        confirm = t(:'.confirmations.destroy', :model_name => name)
        options.reverse_merge!(:method => :delete, :confirm => confirm)
      end

      link_text = args.shift if args.first.is_a?(String)
      link_text = t(args.shift) if args.first.is_a?(Symbol)
      link_text ||= t(:".#{[scope, action].compact.join('.')}")

      url = globalize_url(url_for_action(action, args))
      link_to(link_text, url, options)
    end
  end

  def globalize_url(url)
    add_url_param(:cl, @resource_locale.to_s, url).html_safe
  end

  def glink_to(text, url, options={})
    link_to(text, globalize_url(url), options)
  end

  def gurl_for(*args)
    globalize_url(url_for([*args]))
  end

end