class Content < ActiveRecord::Base

  TRANSLATED_FIELD = [
    :title, :body
  ].freeze

  translates *TRANSLATED_FIELD

  class Translation
    attr_accessible :locale
  end

  attr_accessible :title, :body 

  acts_as_list :scope => [:section_id]
  include Extensions::Models::BelongsToSection
  include Extensions::Models::Sluggable
  include Extensions::Models::Publishable
  include Extensions::Models::HasManyImageAssignments

  #Usage : @content = Content.random
  def self.random
    offset(rand(count)).first if count > 0
  end

  def self.randoms(count = 1)
    live.sample(count)
  end

  def self.previous(record, field = "published_at")
    with_section(record.section_id).published.with_translations(I18n.locale).order("#{table_name}.#{field} ASC").where("#{table_name}.#{field} < ?", record.send(field)).last
  end

  def self.next(record, field = "published_at")
    with_section(record.section_id).published.with_translations(I18n.locale).order("#{table_name}.#{field} ASC").where("#{table_name}.#{field} > ?", record.send(field)).first
  end

  def self.popular(count = 4)
    unscoped.published.with_translations(I18n.locale).order("#{table_name}.access_count DESC").limit(count)
  end

  validates :title, :presence => true, :uniqueness => {:scope => :section_id, :case_sensitive => false}

  def next(field = "published_at")
    self.class.next(self)
  end

  def previous(field = "published_at")
    self.class.previous(self)
  end

  # Indicate if this page should be included in robot.txt
  # use trackable? rather than checking the attribute directly. this
  # allows sub-classes to override trackable? if they want to provide
  # their own definition.
  def trackable?
    published?
  end
end
