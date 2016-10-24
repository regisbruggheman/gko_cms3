xml.url do
  xml.loc "#{@base_url}#{public_url}"
  @other_locales.each do |l|
    unless alternate_url = node.public_url(l)
      xml.xhtml(:link, :rel => 'alternate', :hreflang => l.to_s, :href => alternate_url)
    end
  end
  xml.lastmod node.updated_at.to_date
  xml.priority priority ? priority : 1
end