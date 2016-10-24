module Gko
  module Themes
    module ViewsHelper
      def color_field(key, object, form, style_name = "color", default_value = nil)
        value = object.send(key) || default_value || "rgb(122, 122, 122)"
        # form.input(key, :wrapper => :append, :label => false, :class => 'color', :data => {:color => "#{value}", :'color-format' => 'rgb'}) do
        #   form.input_field(:name, :readonly => true) + "<span class='add-on'><i style='#{style_name}: #{value}; '></i></span>".html_safe
        # end
        "<div class='well'><div class='input-prepend input-append color' data-color='#{value}' data-color-format='rgb' id='key'><span class='add-on'><label>#{key}</label></span><input type='text' class='span6 readonly' value='#{value}' readonly='readonly'><span class='add-on'><i style='#{style_name}: #{value}; '></i></span></div></div>".html_safe
      end
    end
  end
end