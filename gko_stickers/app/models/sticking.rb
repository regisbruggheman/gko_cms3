class Sticking < ActiveRecord::Base
  #----- Associations ----------------------------------------------------------
  belongs_to :sticker
  belongs_to :stickable, :polymorphic => true
end
