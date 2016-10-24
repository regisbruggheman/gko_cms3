# encoding: utf-8
module Admin::GkoBaseHelper

  def li_tab_for(href, label, css = '')
    li_options = {}
    li_options[:class] = css unless css.blank?
    content_tag(:li, li_options) do
      link_to(label, href, :data => { :toggle => 'tab' }).html_safe
    end
  end
  
  def content_tag_for_actions(&block)
    content_tag(:td, :class => :actions) do
      content_tag(:p, capture { block.call }).html_safe
    end
  end

  def preference_field(form, field, options)
    case options[:type]
      when :integer
        form.text_field(field, {
            :size => 10,
            :class => 'input_integer',
            :readonly => options[:readonly],
            :disabled => options[:disabled]
        }
        )
      when :boolean
        form.check_box(field, {:readonly => options[:readonly],
                               :disabled => options[:disabled]})
      when :string
        form.text_field(field, {
            :size => 10,
            :class => 'input_string',
            :readonly => options[:readonly],
            :disabled => options[:disabled]
        }
        )
      when :password
        form.password_field(field, {
            :size => 10,
            :class => 'password_string',
            :readonly => options[:readonly],
            :disabled => options[:disabled]
        }
        )
      when :text
        form.text_area(field,
                       {:rows => 5, :readonly => options[:readonly],
                        :disabled => options[:disabled]}
        )
      else
        form.text_field(field, {
            :size => 10,
            :class => 'input_string',
            :readonly => options[:readonly],
            :disabled => options[:disabled]
        }
        )
    end
  end

  def preference_fields(object, form)
    return unless object.respond_to?(:preferences)
    object.preferences.keys.map { |key|
      form.input(:"preferred_#{key}", :label => t("simple_form.labels.preference.#{key}"), :as => object.preference_type(key))
    }.join("").html_safe
  end

  def preference_fields_for_array(preferences, object, form)
    preferences.map { |key|
      next if !object.respond_to?(:"preferred_#{key}")
      form.input(:"preferred_#{key}", :label => t("simple_form.labels.preference.#{key}"), :as => object.preference_type(key))
    }.join("").html_safe
  end

  def published_status(node)
    status = node.published? ? 'ok-sign' : 'info-sign'
    #TODO Should have a particular title for each kind of resource
    title = node.published? ? "Publiée le #{l(node.published_at)}" : "Cette page n&#x27;est pas en ligne"
    "<a href='#' title='#{title}' rel='tooltip' class='info-tooltip'><i class='icon-#{status}'></i></a>".html_safe
  end

  def icons_to_actions(actions, *args)
    actions.map { |action| capture { send(:"icon_to_#{action}", *args) } }.join('&nbsp;').html_safe
  end

  [:index, :new, :show, :edit, :destroy, :view].each do |action|
    define_method(:"icon_to_#{action}") do |*args|
      options = args.extract_options!
      options[:title] = icon_tooltip(action) unless options.key?(:title)
      options[:class] = action.to_s
      options_for_destroy_action(args, options) if action == :destroy
      options.reverse_merge!(:target => '_blank') if action == :view
      url = url_for_action(action, args)
      icon = icon_for_action(action, options)
      capture { icon_to(globalize_url(url), icon, options) }
    end

    define_method(:"button_to_#{action}") do |*args|
      options = args.extract_options!
      text = options.delete(:title) || icon_tooltip(action) || action.to_s
      options_for_destroy_action(args, options) if action == :destroy
      options.reverse_merge!(:target => '_blank') if action == :view
      url = url_for_action(action, args)
      options[:'icon'] = icon_for_action(action, options)
      capture { btn_to(text, globalize_url(url), options) }
    end

    define_method(:"link_to_#{action}") do |*args|
      options = args.extract_options!
      text = options.delete(:title) || icon_tooltip(action) || action.to_s
      icon = options.key?(:icon) ? options.delete(:icon) : action

      icon = "back" if action == :index
      icon = "th-list" if action == :show
      icon = "trash" if action == :destroy

      options_for_destroy_action(args, options) if action == :destroy
      if action == :view
        icon = "eye-open"
        options.reverse_merge!(:target => '_blank')
      end

      options.reverse_merge!(:icon => icon)
      url = url_for_action(action, args)
      capture { link_to(text, globalize_url(url), options) }
    end
  end

  def btn_to(text, url, options = {})
    url ||= "javascript:void(0)"
    icon = options.delete(:icon) if options.key?(:icon)
    options[:rel] = 'tooltip' if options.key?(:title)
    options[:class] = ['danger', options.delete(:class)].compact.uniq * ' ' if options.key?(:confirm)
    css = ["btn"]
    options[:class] = [css, options.delete(:class)].compact.uniq * ' '
    s = ""
    s += "<i class='icon-#{icon}'></i>&nbsp;" if icon
    s += text
    
    #options[:class] << ' btn-icon' if icon && text
    options[:locale => nil]
    link_to(url, options) { s.html_safe }
  end
  def icon_to(url, icon, options={})
    url ||= "javascript:void(0)"
    btn_class = options.key?(:confirm) ? ['btn btn-danger'] : ['btn']
    options[:rel] = 'tooltip' if options.key?(:title)
    options[:class] = [btn_class, options.delete(:class)].compact.uniq * ' '
    link_to(url, options) do
      "<i class='icon-#{icon} #{'icon-white' if options.key?(:confirm)}'></i>".html_safe
    end
  end

  def icon_link_to(url="#", options={})
    action = options.key?(:action) ? options.delete(:action).to_sym : action_name.to_sym
    icon = options.key?(:icon) ? options.delete(:icon) : action
    text = options.key?(:text) ? options.delete(:text) : false
    scope = options.key?(:scope) ? options.delete(:scope) : "admin.#{controller_name}.actions"
    title = options.key?(:title) ? options.delete(:title) : action
    title = icon_tooltip(title) if title.is_a?(Symbol)
    options[:title] = title
    css_base = [:btn, action]
    css_base << :tooltip if title
    if text
      css_base << :'btn-icon-left'
    else
      css_base << :'btn-no-text'
    end
    options[:class] = [css_base, options.delete(:class)].compact.uniq * ' '

    output = ""
    if icon.is_a?(Symbol) || icon.is_a?(String)
      output << content_tag(:span, "", :class => [:icon, :"icon-#{icon.to_s}"])
    elsif icon.is_a?(TrueClass)
      output << content_tag(:span, "", :class => "icon")
    end
    output << content_tag(:span, "", :class => 'btn-text')

    link_to(url, options) do
      content_tag(:div, output.html_safe, :class => 'btn-inner')
    end
  end

  # renders set of hidden fields and button to add new record using nested_attributes
  def link_to_add_fields(name, append_to_selector, f, association, options={})
    path = options.has_key?(:path) ? options.delete(:path) : '' 
    partial = options.has_key?(:partial) ? options.delete(:partial) : (association.to_s.singularize + "_fields")
    options[:class] = options.has_key?(:class) ? (options[:class] += ' add_fields') : 'btn add_fields'
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(path + partial, :f => builder)
    end
 
    link_to_function(name, raw("add_fields(\"#{append_to_selector}\", \"#{association}\", \"#{escape_javascript(fields)}\")"), options)
  end
  
  def link_to_add_fields2(name, target, options = {})
    name = '' if options[:no_text]
    css_classes = options[:class] ? options[:class] + " add_fields" : "add_fields"
    btn_to(name, 'javascript:', :data => { :target => target }, :class => css_classes)
  end

  # renders hidden field and link to remove record using nested_attributes
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + btn_to(name, '#', :class => ' btn-danger remove_fields', :icon => 'trash icon-white', :inline => true)
  end

  def icon_to_remove_fields(f, options={})
    options[:class] = 'btn-danger remove_fields delete'
    options[:inline] = true
    f.hidden_field(:_destroy) + icon_to('#', 'trash icon-white', options)
  end

  def icon_tooltip(action)
    t(:"admin.#{controller_name}.actions.#{action.to_s}", :default => :"actions.#{action.to_s}")
  end

  # indicate if a resource is currently being translating
  def translating?
    action_name == 'edit' and @resource_locale.to_sym != current_site.default_locale.to_sym
  end

  def display_language_links?
    resources_controller? and current_site and current_site.localized? and controller_name.classify.constantize.base_class.respond_to?(:translation_class) 
  end

  def action_name
    if (params[:action] =~ /^(create|new)$/)
      a = "new"
    elsif (params[:action] =~ /^(edit|update)$/)
      a = "edit"
    end
    a ||= params[:action]
  end

  # Get all types for a STI active record class
  def active_record_types_option_values(clazz)
    clazz.types.map do |type|
      [t(:"activerecord.models.#{type.demodulize.underscore}"), type]
    end
  end
  
  private

  def options_for_destroy_action(args, options={})
    model = args.last.class.respond_to?(:model_name) ? args.last : controller.resource
    confirm = if options.key?(:confirm)
                options.delete(:confirm)
              else
                t("confirmations.destroy.#{model.class.model_name.underscore.downcase}",
                  :default => t("confirmations.destroy.default"))
              end
    options[:theme] = 'x'
    options.reverse_merge!(:method => :delete, :confirm => confirm)
  end

  def icon_for_action(action, options={})
    if options.key?(:icon)
      options.delete(:icon)
    elsif action == :index
      "back"
    elsif action == :show
      "th-list"
    elsif action == :destroy
      "trash"
    elsif action == :view
      "eye-open"
    elsif action == :edit
      "pencil"
    else
      action.to_s
    end
  end

  def url_for_action(action, args)
    action = action.to_sym
    if args.first.is_a?(String)
      args.first
    elsif action == :view && args.last.respond_to?(:public_url)
      args.last.public_url
    elsif action == :index
      controller.send(:collection_url, args)
    elsif action == :show || action == :destroy
      controller.send(:resource_url, args)
    elsif action == :edit
      controller.send(:edit_resource_url, args)
    elsif action == :new
      controller.send(:new_resource_url, args)
    end
  end

end