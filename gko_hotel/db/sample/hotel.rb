puts "add image to main page"
assign_images_to_content(@main_page)

puts "==================\ncreating bedrooms page"
@bedroom_section = @site.pages.create!(
    :title => "Bedrooms",
    :site_id => @site.id,
    :parent_id => @main_page.id,
    :body => Faker::HTMLIpsum.p(8),
    :display_first_page => true,
    :published_at => now)

3.times do |i|
  @page = @site.pages.create!(
      :title => "Beadroom #{Faker::Lorem.words(2)}",
      :site_id => @site.id,
      :parent_id => @bedroom_section.id,
      :body => Faker::HTMLIpsum.p(8),
      :published_at => now)

  assign_images_to_content(@page)
end

puts "==================\ncreating rates page"
@rates_section = @site.pages.create!(
    :title => "Rates and Packages",
    :site_id => @site.id,
    :parent_id => @main_page.id,
    :body => Faker::HTMLIpsum.p(8),
    :display_first_page => true,
    :published_at => now)

@page = @site.pages.create!(
    :title => "Rates",
    :site_id => @site.id,
    :parent_id => @rates_section.id,
    :body => (Faker::HTMLIpsum.p(2) + Faker::HTMLIpsum.table(6) + Faker::HTMLIpsum.p(1)),
    :published_at => now)

3.times do |i|
  @page = @site.pages.create!(
      :title => "Package #{Faker::Lorem.words(2)}",
      :site_id => @site.id,
      :parent_id => @rates_section.id,
      :body => (Faker::HTMLIpsum.p(2) + Faker::HTMLIpsum.table(6) + Faker::HTMLIpsum.p(1)),
      :published_at => now)

  assign_images_to_content(@page)
end

puts "==================\ncreating services page"
@services_section = @site.pages.create!(
    :title => "Services et Activités",
    :site_id => @site.id,
    :parent_id => @main_page.id,
    :body => Faker::HTMLIpsum.p(4),
    :display_first_page => true,
    :published_at => now)

4.times do |i|
  @page = @site.pages.create!(
      :title => "Service #{Faker::Lorem.words(2)}",
      :site_id => @site.id,
      :parent_id => @services_section.id,
      :body => Faker::HTMLIpsum.p(5),
      :published_at => now)

  assign_images_to_content(@page)
end

puts "==================\ncreating restaurants page"
@restaurants_section = @site.pages.create!(
    :title => "Restaurant",
    :site_id => @site.id,
    :parent_id => @main_page.id,
    :body => Faker::HTMLIpsum.p(4),
    :display_first_page => true,
    :published_at => now)

4.times do |i|
  @page = @site.pages.create!(
      :title => "#{Faker::Lorem.words(3)}",
      :site_id => @site.id,
      :parent_id => @restaurants_section.id,
      :body => Faker::HTMLIpsum.p(5),
      :published_at => now)

  assign_images_to_content(@page)
end