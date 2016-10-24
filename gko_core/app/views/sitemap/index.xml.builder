cache [controller_name, action_name, site] do
  xml.instruct!
  xml.urlset( {"xmlns" => 'http://www.sitemaps.org/schemas/sitemap/0.9', 
              "xmlns:xsi" => 'http://www.w3.org/2001/XMLSchema-instance', 
              "xsi:schemaLocation" => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd',
              "xmlns:xhtml" => "http://www.w3.org/1999/xhtml"}) do
    render_tree @sections do |node, child|
      @available_locales.each do |l|
        @other_locales = @available_locales.reject {|e| e = l}
        xml << render("sitemap/node", :node => node, :child => child, :locale => l)
      end
    end
  end
end