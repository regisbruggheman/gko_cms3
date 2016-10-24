####################################################
puts "creating portfolio"
@user ||= User.first
@site ||= Site.first
@portfolio = @site.portfolios.first || @site.portfolios.find_or_create_by_name!(
    :name => "my portfolio",
    :title => "my portfolio",
    :parent_id => @site.sections.root.id,
    :accept_categories => true,
    :accept_stickers => true,
    :published_at => Time.zone.now)
    
@portfolio.categories.map(&:destroy)
@portfolio.stickers.map(&:destroy)
@portfolio.projects.map(&:destroy)

####################################################
puts "creating portfolio categories"
10.times do |i|
  @portfolio.categories.create!(:title => "Portfolio category #{i}")
end
####################################################
puts "creating portfolio stickers"
20.times do |i|
  @portfolio.stickers.create!(:name => "Portfolio tag #{i}")
end
####################################################
puts "creating projects"
30.times do |i|
  @project = @portfolio.projects.create!(
      :title => "My recent project #{i}",
      :body => lorem,
      :published_at => rand(3.months).ago,
      :account_id => @account.id)

  2.times do
    @project.categorizations.create(:category_id => random_resource(Category).id)
  end

  7.times do
    @project.stickings.create(:sticker_id => random_resource(Sticker).id)
  end

  2.times do
    @project.image_assignments.create(:image => random_resource(Image))
  end
end

50.times do |i|
  @project = @portfolio.projects.create!(
      :title => "My project archive #{i}",
      :body => lorem,
      :published_at => rand(2.years).ago,
      :account_id => @account.id)

  2.times do
    @project.categorizations.create(:category_id => random_resource(Category).id)
  end

  7.times do
    @project.stickings.create(:sticker_id => random_resource(Sticker).id)
  end

  2.times do
    @project.image_assignments.create(:image => random_resource(Image))
  end
end

