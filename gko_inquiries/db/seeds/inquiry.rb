puts "creating contact page"
@site.pages.create!(
    :title => "Contact us",
    :site_id => @site.id,
    :parent_id => @main_page.id,
    :redirect_url => "contact.html",
    :published_at => now)