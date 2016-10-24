module MinimalHelper

  def render_alert_message(msg, options={})
    content_tag(:div, "<button type='button' class='close' data-dismiss='alert'>&times;</button>#{msg}".html_safe, :class => 'alert success')
  end
  
  def render_copy_text(txt, options={})
    classes = ['copy-text', options.delete(:class)].compact.uniq * ' '
    content_tag(:div, txt.html_safe, :class => classes).html_safe if txt.present?
  end
  # depreciate use render_copy_text
  def render_html_text(txt)
    content_tag(:div, txt.html_safe, :class => :'html-text').html_safe if txt.present?
  end

  def render_page_title(txt)
    content_tag(:h1, txt.html_safe, :class => :'page-title').html_safe if txt.present?
  end

  def grid_tag(columns=1, options={}, &block)
    content_tag(:ul, :class => "grid grid#{columns.to_s} mobile", :id => "grid-#{resource_collection_name}") do
      capture(&block)
    end
  end

  # render li tag and thumbnail div
  def grid_item_tag_for(*args, &block)
    record      = args.first
    html_options = args.second || {}

    content_tag_for(:li, record, html_options) do
      content_tag(:div, :class => 'thumbnail') do
        capture(&block)
      end
    end
  end

  def grid_item_caption_tag(&block)
    content_tag(:div, :class => "caption") do
      capture(&block)
    end
  end

  def render_record_title(record, options={})
    content_tag(:h2, :class => 'title') do
      if record.trackable?
        link_to(record.title, record.public_url, :rel => 'bookmark')
      else
        record.title
      end
    end if record
  end

  def thumbnail_image(record, options={})
    if record.is_a?(String)
      image_tag(record)
    else
      size = options.key?(:size) ? options.delete(:size) : site.preferred_image_grid_size
      if thumb = record.thumbnail
        content_tag(:div, :class => 'image') do
          if record.trackable?
            link_to(image_fu(thumb, size), record.public_url)
          else
            image_fu(thumb, size)
          end
        end
      elsif default_thumb = site.default_image
        content_tag(:div, :class => 'image') do
          if record.trackable?
            link_to(image_tag(default_thumb.thumb(size).url), record.public_url)
          else
            image_tag(default_thumb.thumb(size).url)
          end
        end
      end
    end
  end

  def render_record_thumb(record, options={})
    if record.is_a?(String)
      image_tag(record)
    else
      size = options.key?(:size) ? options.delete(:size) : site.preferred_image_grid_size
      if thumb = record.thumbnail
        content_tag(:div, :class => 'image') do
          if record.trackable?
            link_to(image_fu(thumb, size), record.public_url)
          else
            image_fu(thumb, size)
          end
        end
      elsif default_thumb = site.default_image
        content_tag(:div, :class => 'image') do
          if record.trackable?
            link_to(image_tag(default_thumb.thumb(size).url), record.public_url)
          else
            image_tag(default_thumb.thumb(size).url)
          end
        end
      end
    end
  end

  def render_record_link(record, label = nil)
    label ||= t("#{resource_collection_name}.collection.continue", :default => t("continue"))
    content_tag(:div, :class => 'links') do
      link_to(label, record.public_url, :class => 'btn btn-link continue')
    end if record
  end

  def render_record_description(record, length = nil, omission = nil)
    omission ||= record.section.listing_omission
    length ||= record.section.listing_description_length
    content_tag(:p, :class => 'description') do
      truncate_html(strip_tags(record.body), :length => length, :omission => omission)
    end if record.body.present? && length > 0
  end

  def render_publication_date(record, format="post")
    content_tag(:time, l(record.published_at, :format => format.to_sym), :datetime => l(record.published_at, :format => :default))
  end

  def meta_tag(tag, value)
    "<span class='tag #{tag.to_s}'><strong>#{t("metas.#{tag.to_s}")}: </strong>#{value}</span>" unless value.blank?
  end

  def render_slideshow_for(item, options = {})
    path = options.delete(:plugin) || site.slideshow || 'flexslider'
    options[:images] = item.images
    render("images/#{path}", options) if item && item.images.any?
  end

  def render_next_previous(item = resource)
    render('next_previous', :record => item) if item
  end

  def render_resource(instance_name = resource_instance_name)
    content_tag(:article, :class => "#{instance_name}") do
      render("resource", :resource => resource)
    end
  end

  def render_collection_header
    render("collection_header", :parent => parent)
  end

  def render_collection(collection_name = resource_collection_name)
    content_tag(:section, :class => "grid-container #{collection_name}") do
      render("records") #rescue render("contents/record", :as => :record)
    end
  end

  def render_resource_categories(options={})
    if resource_has_categories?
      title = options.delete(:title) || t(:"categories.title")
      render('resource_categories', :title => title)
    end
  end

  def render_resource_stickers(options={})
    if resource_has_stickers?
      title = options.delete(:title) || t(:"stickers.title")
      render('resource_stickers', :title => title)
    end
  end

  def render_parent_categories(options={})
    if parent_has_categories?
      title = options.delete(:title) || t(:"categories.title")
      render('parent_categories', :title => title)
    end
  end

  def render_parent_stickers(options={})
    if parent_has_stickers?
      title = options.delete(:title) || t(:"stickers.title")
      render('parent_stickers', :title => title)
    end
  end

  def render_menu(name)
    if(name == 'primary' || name == 'secondary')
      render("#{name}_menu")
    elsif menu = site.sections.roots.find_by_name(name)
      content_tag(:nav, :class => "#{name}-menu-container") do
        render 'simple_menu', :sections => menu.children.in_menu, :menu_name => menu.name
      end if menu.children.in_menu.any?
    end
  end

  def menu_link(section, options = {})
    dropdown = options.key?(:dropdown) ? options.delete(:dropdown) : false
    if section.is_a?(Redirect)
      if section.redirect_url.presence
        link = section.redirect_url
        options[:target] = "_blank" if link and link.starts_with?("http", "https", "ftp")
      elsif section.link.present?
        link = section.link.public_url
      end
    elsif section.display_first_page and page = section.children.in_menu.first
      link = page.public_url
    else
      link = section.public_url
    end
    if section.menu_css_class.present?
      options[:class] = ["#{section.menu_css_class}", options.delete(:class)].compact.uniq * ' '
    end
    options[:id] = section.name if section.name?
    options[:tabindex] = -1
    if dropdown
      options[:class] = ["dropdown-toggle", options.delete(:class)].compact.uniq * ' '
      options[:'data-toggle'] = "dropdown"
      options[:'data-hover'] = "dropdown"
      options[:'data-target'] = "##{dom_id(section)}"
    end
    s = "#{section.menu_title.blank? ? section.title : section.menu_title}"
    
    if dropdown
      s += options.key?(:caret) ? options.delete(:caret) : "<span class='caret'></span>"  
    end
    
    link_to(link, options) { s.html_safe } if link
  end

end
