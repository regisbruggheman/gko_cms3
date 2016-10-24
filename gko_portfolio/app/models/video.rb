class Video < ActiveRecord::Base
  belongs_to :content, :touch => true
  attr_accessible :content_id, :address, :title

  #validates :address, :presence => true
end