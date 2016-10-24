####################################################
puts "creating blog"
@account ||= Account.first
@user ||= @account.users.first
@site ||= @account.sites.first
@blog = @site.blogs.first || @site.blogs.find_or_create_by_name!(
    :name => "my blog",
    :title => "my blog",
    :parent_id => @site.sections.root.id,
    :accept_categories => true,
    :accept_stickers => true,
    :published_at => Time.zone.now)

@blog.categories.map(&:destroy)
@blog.stickers.map(&:destroy)
@blog.posts.map(&:destroy)
    
####################################################
puts "creating blog categories"
10.times do |i|
  @blog.categories.create!(:title => "Blog category #{i}")
end
####################################################
puts "creating blog stickers"
20.times do |i|
  @blog.stickers.create!(:name => "Blog tag #{i}")
end
####################################################
puts "creating posts"
30.times do |i|
  @post = @blog.posts.create!(
      :title => "My recent post #{i}",
      :body => lorem,
      :published_at => rand(3.months).ago,
      :account_id => @account.id)

  2.times do
    @post.categorizations.create(:category_id => random_resource(Category).id)
  end

  7.times do
    @post.stickings.create(:sticker_id => random_resource(Sticker).id)
  end

  2.times do
    @post.image_assignments.create(:image => random_resource(Image))
  end
end

50.times do |i|
  @post = @blog.posts.create!(
      :title => "My post archive #{i}",
      :body => lorem,
      :published_at => rand(2.years).ago,
      :account_id => @account.id)

  2.times do
    @post.categorizations.create(:category_id => random_resource(Category).id)
  end

  7.times do
    @post.stickings.create(:sticker_id => random_resource(Sticker).id)
  end

  2.times do
    @post.image_assignments.create(:image => random_resource(Image))
  end
end

