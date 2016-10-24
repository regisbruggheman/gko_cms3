require 'faker'

def rand_in_range(from, to)
  rand * (to - from) + from
end

def rand_int(from, to)
  rand_in_range(from, to).to_i
end

##------------------------------------------------------- 
@site ||= Site.first
##------------------------------------------------------- 
puts "creating features"
4.times do |i|
  @feature = @site.features.create!(
      :title => Faker::Lorem.words(rand_int(2, 5)).to_s,
      :body => Faker::Lorem.words(rand_int(8, 20)).to_s,
      :published_at => Time.zone.now)
end