module ImagesHelper

  def image_geometry(scale = 1.55)
    case request.env['mobvious.device_type']
    when :mobile
      "480x320#"
    when :tablet
      "1024x768#"
    else
      "1140x734#"
    end
  end

  # image_fu is a helper for inserting an image that has been uploaded into a template.
  # Say for example that we had a @model.image (@model having a belongs_to :image relationship)
  # and we wanted to display a thumbnail cropped to 200x200 then we can use image_fu like this:
  # <%= image_fu @model.image, '200x200' %> or with no thumbnail: <%= image_fu @model.image %>
  def image_fu(image, geometry = nil, options={})
    #image ||= Dragonfly[:images].fetch_file('/assets/images/missing_image.jpg')
    if image.present?
      dimensions = (image.thumbnail_dimensions(geometry) rescue {})
      if process = options.delete(:process)
        image_tag(image.thumbnail.black_and_white(geometry).url(), { :alt => ''}.merge(options))
      else
        image_tag(image.thumbnail(geometry).url(), { :alt => ''}.merge(options))
      end
      #.merge(dimensions)
    end
  end
  
  
end