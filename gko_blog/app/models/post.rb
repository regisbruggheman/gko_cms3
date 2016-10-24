class Post < Content

  class << self
    def by_permalink(year, month, day, slug)
      where("DATE(contents.published_at) = ?", Date.new(year.to_i, month.to_i, day.to_i).to_formatted_s(:db)).with_globalize(:slug => slug)
    end
  end

  def permalink(locale=nil)
    if published?
      s = read_attribute(:slug, :locale => locale || ::Globalize.locale)
      "#{published_at.year}/#{published_at.month}/#{published_at.day}/#{s}"
    end
  end

end
