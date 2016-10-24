module Admin::ImagesHelper
  
  def image_infos(image)
    [raw("<b>#{t(:"admin.images.infos.name")}:</b> #{image.title}"),
     raw("<b>#{t(:"admin.images.infos.size")}:</b> #{number_to_human_size(image.size)}"),
     raw("<b>#{t(:"admin.images.infos.type")}:</b> #{image.mime_type}"),
     raw("<b>#{t(:"admin.images.infos.dimensions")}:</b> #{image.width}x#{image.height}")].compact.join("<br/>").html_safe
  end

  def document_infos(document)
    [raw("<b>#{t(:"admin.documents.infos.name")}:</b> #{document.name}"),
     raw("<b>#{t(:"admin.documents.infos.size")}:</b> #{number_to_human_size(document.size)}"),
     raw("<b>#{t(:"admin.documents.infos.type")}:</b> #{document.mime_type}")].compact.join("<br/>").html_safe
  end
  
end