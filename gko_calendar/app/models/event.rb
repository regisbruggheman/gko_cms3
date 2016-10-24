class Event < ActiveRecord::Base
  include Extensions::Models::Translatable
  include Extensions::Models::BelongsToSection
  include Extensions::Models::Publishable
  include Extensions::Models::Categorizable
  translates :title, :body, :slug
  belongs_to :owner, :polymorphic => true
  image_accessor :image
  attr_accessible (:parent_id, :title,:body, :all_day, :start_date, :end_date, :slug, :location, :contact_email, :more_info_url, :registration_url)
  #----- Class methods -----------------------------------------------------------
  class << self
    def trackable?
      true
    end

    def by_permalink(year, month, day, slug)
      #by_archive(year, month, day).where(:slug => slug)
      by_archive(year, month, day).joins(:translations).where("#{self.translation_class.table_name}.slug = ?", slug)
    end

    def upcoming(*args) #year, month, day
                        #DATE(events.start_date) IS NOT NULL AND  never null ?
      where("DATE(events.start_date) >= ?", Date.new(*args.map(&:to_i)).to_formatted_s(:db)).order("events.start_date DESC")
    end

    def elapsed(*args) #year, month, day
                       #DATE(events.start_date) IS NOT NULL AND  never null ?
      where("DATE(events.start_date) >= ?", Date.new(*args.map(&:to_i)).to_formatted_s(:db)).order("events.start_date DESC")
    end

    def by_archive(*args)
      where("DATE(events.start_date) = ?", Date.new(*args.map(&:to_i)).to_formatted_s(:db))
    end

    def previous(record, field = "start_date")
      with_section(record.section_id).where("#{field} < ?", record.send(field)).order("#{field} DESC")
    end

    def next(record, field = "start_date")
      with_section(record.section_id).where("#{field} > ?", record.send(field)).order("#{field} ASC")
    end
  end

  validates :title, :presence => true
  validates :start_date, :presence => true
  #validates :body, :presence => true

  before_validation do |r|
    r.slug = r.title if r.slug.blank? && r.title.present?
    r.slug = r.slug.parameterize if slug_changed? && r.slug.present?
  end

  def owner_name
    owner.title if owner
  end

  def link
    return url if url.present?
    return owner_name
  end

  def next(field = "start_date")
    self.class.next(self, field).first
  end

  def previous(field = "start_date")
    self.class.previous(self, field).first
  end

  def permalink
    "#{start_date.year}/#{start_date.month}/#{start_date.day}/#{slug}"
  end

  def to_param(title=nil)
    title == :permalink ? permalink : super()
  end

  def thumbnail
    image
  end

  def trackable?
    self.class.trackable?
  end

end
