require 'faker'

def rand_in_range(from, to)
  rand * (to - from) + from
end

def rand_int(from, to)
  rand_in_range(from, to).to_i
end

def rand_price(from, to)
  rand_in_range(from, to).round(2)
end

##------------------------------------------------------- 
@site ||= Site.first
@main_page ||= @site.pages.find_by_name('root')
@user ||= User.first
##------------------------------------------------------- 
puts "creating services page"
@services_page = @site.sections.create!({
                                            :parent_id => @main_page.id,
                                            :type => 'ServiceList',
                                            :title => 'Services',
                                            :published_at => Time.zone.now})
##------------------------------------------------------- 
puts "creating services"
10.times do |i|
  @service = @services_page.services.create!(
      :title => "Service #{i}",
      :body => "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nulla nonummy aliquet mi. Proin lacus. Ut placerat. Proin consequat, justo sit amet tempus consequat, elit est adipiscing odio, ut egestas pede eros in diam. Proin varius, lacus vitae suscipit varius, ipsum eros convallis nisi, sit amet sodales lectus pede non est. Duis augue. Suspendisse hendrerit pharetra metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Curabitur nec pede. Quisque volutpat, neque ac porttitor sodales, sem lacus rutrum nulla, ullamcorper placerat ante tortor ac odio. Suspendisse vel libero. Nullam volutpat magna vel ligula. Suspendisse sit amet metus. Nunc quis massa. Nulla facilisi. In enim. In venenatis nisi id eros. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nunc sit amet felis sed lectus tincidunt egestas. Mauris nibh.",
      :published_at => Time.zone.now,
      :account_id => @user.account.id,
      :price => rand_price(200, 1800))

  if Image.count > 0
    2.times do
      image = Image.find(rand_int(1, Image.count))
      @service.image_assignments.create(:image => image) if image
    end
  end
end 