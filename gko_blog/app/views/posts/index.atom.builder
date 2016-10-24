atom_feed({:id => "tag:#{site.host},2011:atom"}) do |feed|
  feed.title(site.title)
  feed.updated(@posts.first.published_at)
  @posts[0, 15].each do |post|
    feed.entry([parent, post], :id => "tag:#{site.host},2011:#{post.slug}") do |entry|
      entry.title(post.title)
      entry.content(post.body, :type => 'html')
      entry.updated(post.published_at.xmlschema)
    end
  end
end
