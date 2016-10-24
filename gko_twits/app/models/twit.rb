class Twit < ActiveRecord::Base
  include Extensions::Models::BelongsToSection
  include Extensions::Models::Publishable
  include Extensions::Models::Translatable
  translates :body
  attr_accessible :body

  #----- Class methods -----------------------------------------------------------
  class << self
    def trackable?
      false
    end

    def by_archive(*args)
      where("DATE(twits.published_at) = ?", Date.new(*args.map(&:to_i)).to_formatted_s(:db))
    end

    def previous(record, field = "published_at")
      with_section(record.section_id).where("#{field} < ?", record.send(field)).order("#{field} DESC")
    end

    def next(record, field = "published_at")
      with_section(record.section_id).where("#{field} > ?", record.send(field)).order("#{field} ASC")
    end

    def live(locale = I18n.locale)
      where(['twits.expire_at IS NULL OR DATE(twits.expire_at) <= ?', Time.now])
    end
  end

  def next(field = "published_at")
    self.class.next(self, field).first
  end

  def previous(field = "published_at")
    self.class.previous(self, field).first
  end

  def permalink
    "#{published_at.year}/#{published_at.month}/#{published_at.day}"
  end

  def to_param(title=nil)
    title == :permalink ? permalink : super()
  end

  def trackable?
    self.class.trackable?
  end
end
