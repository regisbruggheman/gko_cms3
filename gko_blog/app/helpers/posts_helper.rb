module PostsHelper

  def blog_post_teaser_enabled?
    false
    #Blog::Post.teasers_enabled?
  end

  #def blog_post_teaser(post)
  # if post.respond_to?(:custom_teaser) && post.custom_teaser.present?
  #  post.custom_teaser.html_safe
  #  else
  #   truncate(post.body, {
  #     :length => Refinery::Blog.post_teaser_length,
  #     :preserve_html_tags => true
  #    }).html_safe
  #  end
  #end

  def render_blog_archive(dates=blog_archive_dates)
    ArchiveWidget.new(@blog, dates, self).display
  end

  def blog_archive_dates(cutoff = Time.now.beginning_of_month)
    @blog.posts.published_dates_older_than(cutoff)
  end

  #def avatar_url(email, options = {:size => 60})
  #  require 'digest/md5'
  #  "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.to_s.strip.downcase)}?s=#{options[:size]}.jpg"
  #end

  class ArchiveWidget
    delegate :t, :link_to, :blog_path, :render, :to => :view_context
    attr_reader :view_context

    def initialize(blog, dates, view_context, cutoff = 1.years.ago.end_of_year)
      @recent_dates, @old_dates = dates.sort_by {|date| -date.to_i }.partition {|date| date > cutoff }
      @view_context = view_context 
      @current_blog = blog
    end

    def recent_links
      @recent_dates.group_by {|date| [date.year, date.month] }.
        map {|(year, month), dates| recent_link(year, month, dates.count) }
    end

    def recent_link(year, month, count)
      link_to "#{t("date.month_names")[month]} #{year} (#{count})", blog_path(@current_blog, :year => year, :month => month)
    end

    def old_links
      @old_dates.group_by {|date| date.year }.
        map {|year, dates| old_link(year, dates.size) }
    end

    def old_link(year, count)
      link_to "#{year} (#{count})", blog_path(@current_blog, :year => year)
    end

    def links
      recent_links + old_links
    end

    def display
      return "" if links.empty?
      render("blog_archived_posts", :links => links)
    end
  end
end
