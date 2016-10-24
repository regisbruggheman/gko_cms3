# See http://www.robotstxt.org/wc/norobots.html for documentation on how to use the robots.txt file
class RobotsController < BaseController
  layout nil

  def index
    if stale?( :etag => ["robots-index", I18n.locale, site], :last_modified => site.updated_at.utc, :public => true )
      if (Rails.env.development? && local_request?) || (Rails.env.production? && site.public)
        host = request.host
        robot = "User-agent: *\n"
        site.available_locales.each do |language|
          ["admin", "user", "user_sessions", "users", "password_resets"].each do |path|
            unless current_locale?(language.code)
              robot += "Disallow: /#{language.code}/#{path}/\n"
            else
              robot += "Disallow: /#{path}/\n"
            end
          end
        end
        robot += "Sitemap: http://#{host}/sitemap.xml"
      else
        # ban all spiders from the entire site
        robot = <<-EOF
        User-agent: *
        Disallow: /
        EOF
      end
      render :text => robot
    end
  end

end
