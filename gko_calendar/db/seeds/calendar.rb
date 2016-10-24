####################################################
puts "creating calendar"
@calendar = Calendar.find_or_create_by_name(
    :name => "my_calendar",
    :title => "Events",
    :parent_id => @main_page.id,
    :accept_categories => true,
    :accept_stickers => true,
    :published_at => now)

#create_categories_for_section(@calendar)
#create_stickers_for_section(@calendar)

####################################################
puts "creating events"
10.times do |i|
  @event = @calendar.events.create!(
      :title => "Event #{Faker::Lorem.words(1)}-#{i}",
      :body => Faker::HTMLIpsum.p(8),
      :start_date => random_date,
      :published_at => now)

  #assign_categories_to_content(@event)
  #assign_stickers_to_content(@event)
end