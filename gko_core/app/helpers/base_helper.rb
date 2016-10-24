module BaseHelper

  def get_text_element(record, name)
    if element = record.text_elements.named(name)
      raw element.value
    end
  end
  
  #!!!! use both by admin and public
  def render_pagination(items=nil, remote=false)
    items ||= collection
    if items.any? && items.respond_to?(:total_pages) && items.total_pages > 1
      render("pagination", :entries => items, :remote => remote)
    end
  end

  def pin_it_button(image)
    return unless image

    url = image.thumbnail('200x').url()
    media = request.protocol + request.host + image.thumbnail('600x').url()

    description = image.image_name
    link_to('<img src="//assets.pinterest.com/images/pidgets/pin_it_button.png" />'.html_safe , "//pinterest.com/pin/create/button/?url=#{url}&media=#{media}&description=#{description}",
            :data => {
              "pin-config" => "none",
              "pin-do" => "buttonPin"
    }).html_safe
  end

  # SimpleForm does not provide a helper to display base errors.
  # So we need to add the following view helper.
  def display_base_errors(resource)
    # this work return resource.errors.full_messages
    return unless resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
    <button type="button" class="close" data-dismiss="alert">&#215;</button>
    #{messages}
    </div>
    HTML
    html.html_safe
  end

  def formatted_price(price = nil)
    if price.present? and price.to_f > 0
      number_to_currency(price, :precision => 2, :unit => site.preferred_currency)
    else
      t(:'price_on_request')
    end
  end
  # Replace white spaces by no-breaking spaces
  def indivisible_number_to_currency(number, options = {})
    return unless number.present?
    r = number_to_currency(number, options).gsub(' ', '&nbsp;')
    r ? r.html_safe : ""
  end

  def render_collection_head(headers = [])
    content_tag(:thead) do
      content_tag(:tr) do
        s = headers.collect do |x|
          content_tag(:th, t("#{collection_namespace}.#{x}"), :class => "#{x.to_s.underscore.downcase}")
        end
        s << "<th></th>"
        s.join.html_safe
      end
    end.html_safe
  end

  def collection_namespace
    @collection_namespace ||= "simple_form.labels.#{resource_collection_name.to_s.singularize}"
  end

  def page_title(title)
    content_tag(:h1, title.html_safe, :class => "page-title") unless title.blank?
  end

  def format_date(date, format=t(:'date.formats.long'))
    return '' if date.nil?
    I18n.l(date, :format => format)
  end

  # Dynamically add or replcae a param to an url
  def add_url_param(key, value, url=nil)
    url ||= request.fullpath
    uri, query = url.split('?')
    params = query ? Rack::Utils.parse_nested_query(query) : {}
    params[key] = value
    return "#{uri}?#{params.to_query}".html_safe
  end

  protected

  def active_paths
    @active_paths ||= path_and_parents(controller.request.fullpath)
  end

  def path_and_parents(path)
    path.split('/').inject([]) do |paths, segment|
      path = [paths.last == '/' ? '' : paths.last, segment].compact.join('/')
      paths << (path.empty? ? '/' : path)
    end
  end

end
