class Categorization < ActiveRecord::Base
  belongs_to :categorizable, :touch => true, :polymorphic => true
  belongs_to :category
  accepts_nested_attributes_for :category
  attr_accessible :category, :category_id, :categorizable_id, :categorizable_type
end

