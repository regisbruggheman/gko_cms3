require 'highline/import'
# see last line where we create an master if there is none, asking for email and password
def prompt_for_site_title
  title = ask('Title [My site]: ') do |q|
    q.echo = false
    q.validate = /^(|.{1,40})$/
    q.responses[:not_valid] = 'Invalid site title. Must be at least 1 characters long.'
    q.whitespace = :strip
  end
  title = 'My site' if title.blank?
  title
end

def prompt_for_site_host
  host = ask('Host [0.0.0.0:3000]: ') do |q|
    q.echo = true
    q.whitespace = :strip
  end
  host = "0.0.0.0:3000" if host.blank?
  host
end

def prompt_for_example_pages
  if ENV['AUTO_ACCEPT'] or agree("Do you want to create sample pages\ncontinue? [y/n] ")
    ENV['SKIP_NAG'] = 'yes'
    return true
  else
    say "Task cancelled, exiting."
    exit
    return false
  end
end

def create_site
  if ENV['AUTO_ACCEPT']
    title = "My site #{Site.count}"
    host = "0.0.0.0:3000"
  else
    puts 'Create the site (press enter for defaults).'
    title = prompt_for_site_title
    host = prompt_for_site_host
  end
  attributes = {
    :host => host,
    :title => title
  }

  load 'site.rb'

  if Site.where(:host => host).any? #Do not use Site.by_host !!
    say "\nWARNING: There is already a site with the host: #{host}, so no site changes were made.  If you wish to create an additional site, please run rake db:site:create again with a different host.\n\n"
  else
    @site = Site.current = Site.create!(attributes)
    if prompt_for_example_pages

      @primary_menu = @site.sections.named("primary_menu")
      #------------------------------------
      puts "creating pages"
      @primary_menu.children.create!({ :title => "Exemple",
                                       :type => 'Page',
                                       :body => lorem,
                                       :published_at => Time.zone.now})
      @primary_menu.children.create!({:title => "About",
                                      :type => 'Page',
                                      :body => lorem,
                                      :published_at => Time.zone.now})
      @primary_menu.children.create!({:title => "Contact",
                                      :template => 'contact',
                                      :type => 'Page',
                                      :body => lorem,
                                      :published_at => Time.zone.now})
    else

    end
  end
end

create_site