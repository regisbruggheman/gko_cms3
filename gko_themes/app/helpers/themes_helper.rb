# encoding: utf-8
module ThemesHelper
  
  def test_css_erb
    "bob"
  end
  def color_field(key, object, form, style_name = "color", default_value = nil, target=nil)
    #value = object.send(key) || default_value || "rgb(122, 122, 122)"
    value = default_value
    # form.input(key, :wrapper => :append, :label => false, :class => 'color', :data => {:color => "#{value}", :'color-format' => 'rgb'}) do
    #   form.input_field(:name, :readonly => true) + "<span class='add-on'><i style='#{style_name}: #{value}; '></i></span>".html_safe
    # end
    "<div class='input-prepend input-append color' data-target='#{target}' data-style='#{style_name}' data-color='#{value}' data-format='rgb' id='#{key}'><span class='add-on'><label>#{key}</label></span><input type='text' class='span6 readonly' value='#{value}' readonly='readonly'><span class='add-on'><i style='#{style_name}: #{value}; '></i></span></div>".html_safe
  end

  def color_field2(form, object, key, target, options={})
    style_name = options[:style_name] || 'color'
    value = options[:value] || "rgb(122, 122, 122)"
    format = options[:format] || "rgb"
    #value = object.send(key) || default_value || "rgb(122, 122, 122)"
    # form.input(key, :wrapper => :append, :label => false, :class => 'color', :data => {:color => "#{value}", :'color-format' => 'rgb'}) do
    #   form.input_field(:name, :readonly => true) + "<span class='add-on'><i style='#{style_name}: #{value}; '></i></span>".html_safe
    # end

    "<div class='control-group'><label class='control-label' for='#{key}'>#{key}</label><div class='controls'><div class='input-append color' data-target='#{target}' data-style='#{style_name}' data-color='#{value}' data-color-format='#{format}' id='#{key}'><input type='text' class='span6 readonly' value='#{value}' readonly='readonly'><span class='add-on'><i style='#{style_name}: #{value}; '></i></span></div></div></div>".html_safe
  end

  def size_field(form, object, key, target, options={})
    style_name = options[:style_name]
    value = options[:value] || "0"
    format = options[:format] || "px"
    "<div class='control-group'><label class='control-label' for='#{key}'>#{key}</label><div class='controls'><div class='input-append size'  id='#{key}'><input type='text' class='span6 value='#{value}' data-target='#{target}' data-style='#{style_name}' data-color='#{value}' data-format='#{format}'><span class='add-on'><i style='#{style_name}: #{value}; '></i></span></div></div></div>".html_safe
  end

  def size_field2(form, object, key, target, options={})
    style_name = options[:style_name]
    value = options[:value] || "0"
    format = options[:format] || "px"
    "<label class='first'>GROUP</label><input data-type='radius' data-name='global-radii-blocks' value='.6em'/><div class='slider' data-type='radius' data-name='global-radii-blocks' ></div>".html_safe
  end
end
