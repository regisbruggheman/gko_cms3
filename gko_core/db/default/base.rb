require 'dragonfly'
require 'faker'
require 'highline/import'

def create_categories_for_section(section, count = 10)
  puts "creating #{section.title} categories"
  count.times do |i|
    section.categories.create!(:title => "#{Faker::Lorem.words(1)}-#{i}")
  end
end

def create_stickers_for_section(section, count = 20)
  puts "creating #{section.title} stickers"
  count.times do |i|
    section.stickers.create!(:name => "#{Faker::Lorem.words(2)}-#{i}")
  end
end

def assign_categories_to_content(content, count = 2)
  puts "assigning categories to #{content.title}"
  if (c = content.section.categories.count) != 0
    count.times do |i|
      category = content.section.categories.find(:first, :offset => rand(c))
      content.categorizations.create(:category => category)
    end
  end
end

def assign_stickers_to_content(content, count = 7)
  puts "assigning stickers to #{content.title}"
  count.times do |i|
    content.stickings.create(:sticker_id => random_resource(Sticker).id)
  end
end

def assign_images_to_content(content, count = 2)
  puts "assigning images to #{content.title}"
  count.times do |i|
    content.image_assignments.create(:image => random_resource(Image))
  end
end

def rand_in_range(from, to)
  rand * (to - from) + from
end

def rand_int(from, to)
  rand_in_range(from, to).to_i
end

def rand_price(from, to)
  rand_in_range(from, to).round(2)
end

def rand_time(from, to)
  Time.at(rand_in_range(from.to_f, to.to_f))
end

def random_resource(klazz)
  #ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
  #model.find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  if (c = klazz.count) != 0
    klazz.find(:first, :offset => rand(c))
  end
end

def rand_words
  (0..4).inject("") { |s, i| s << (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).rand }
end

def random_date(params={})
  years_back = params[:year_range] || 0
  latest_year = params [:year_latest] || 0
  year = (rand * (years_back)).ceil + (Time.now.year - latest_year - years_back)
  month = (rand * 12).ceil
  day = (rand * 31).ceil
  series = [date = Time.local(year, month, day)]
  if params[:series]
    params[:series].each do |some_time_after|
      series << series.last + (rand * some_time_after).ceil
    end
    return series
  end
  date
end

def rand_with_range(values = nil)
  if values.respond_to? :sort_by
    values.sort_by { rand }.first
  else
    rand(values)
  end
end

def rand_boolean
  rand_with_range(["0", "1"]).to_s
end

def lorem
  "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent posuere ante sed risus aliquam at tincidunt risus scelerisque. Mauris sodales condimentum nulla eu gravida. In nunc nunc, congue sit amet rutrum id, rutrum sed mi. Sed ac arcu lacus. Integer ac nisi sit amet ligula porta adipiscing. In vitae orci neque, eget malesuada metus. Praesent et fringilla mi. Etiam a lectus diam. Etiam porta risus sit amet felis placerat in luctus quam vestibulum. Mauris augue metus, cursus ut interdum ac, pulvinar quis arcu. Aliquam eget erat magna, id sodales est. Vestibulum tincidunt blandit elit, et aliquet massa convallis a. Nulla a lorem eget massa pellentesque dignissim non ut nunc. Cras a mauris sit amet purus ultrices lacinia eu at odio. In orci velit, elementum condimentum euismod vitae, dignissim in odio. Aenean ut nibh ultrices diam facilisis sollicitudin. Vestibulum tellus risus, venenatis in accumsan nec, pharetra ac dui. In diam enim, porttitor vel mollis luctus, placerat ut turpis.</p><p>Duis vel est quis dolor feugiat euismod. Donec porta vulputate sem ac rhoncus. In vulputate pulvinar vulputate. Praesent ac diam ligula, sit amet ultrices neque. Sed ac interdum sem. Maecenas placerat fermentum iaculis. Donec semper quam nisl, in hendrerit lectus. Vestibulum sed velit sem, sed pellentesque sem. Etiam tempor facilisis dictum. Morbi turpis arcu, ultricies sit amet dictum sit amet, ullamcorper in metus. Nunc quis mauris lectus. Vivamus pulvinar leo non sapien consequat interdum.</p>"
end

def now
  Time.zone.now
end


#if Site.count == 0
#  create_site
#else
#  puts 'Site has already been previously created.'
#  if agree('Would you like to create a new site? (yes/no)')
#    create_site
#  else
#    puts 'No site created.'
#  end
#end

