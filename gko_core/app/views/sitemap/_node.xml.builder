cache [controller_name, action_name, request.format, locale, site, node] do
  #if(node.is_a?(Home)) && public_url = node.public_url(locale)
  if public_url = node.public_url(locale)
    xml << render("sitemap/url", :node => node, :locale => locale, :public_url => public_url, :priority => node.is_a?(Home) ? 1 : 0.9)
    if node.content_type && node.content_type.constantize.try(:trackable?)
      collection = node.send(node.collection_table_name).with_translations(locale)
      if collection.try(:any?)
        collection.each do |r|
          if r.trackable? && public_url = r.public_url(locale)
            xml << render("sitemap/url", :node => r, :locale => locale, :public_url => public_url, :priority => 0.7)
          end
        end
      end
    end
  end
  child
end
