class DatePickerInput < SimpleForm::Inputs::StringInput 
  def input                    
    value = object.send(attribute_name).to_date if object.respond_to? attribute_name
    input_html_options[:value] ||= I18n.localize(value, {:format => '%A %d %B %Y'}) if value.present?
    @builder.text_field(attribute_name, input_html_options)
  end
end