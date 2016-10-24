atom_feed({:id => "tag:#{site.host},2011:atom"}) do |feed|
  feed.title(site.title)
  feed.updated(collection.first.published_at)
  collection[0, 15].each do |event|
    feed.entry([blog, event], :id => "tag:#{site.host},2011:#{event.slug}") do |entry|
      entry.title(event.title)
      entry.content(event.body_html, :type => 'html')
      entry.updated(event.published_at.xmlschema)
    end
  end
end
