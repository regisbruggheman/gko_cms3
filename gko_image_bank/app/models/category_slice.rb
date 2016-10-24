Category.class_eval do
  has_many :image_bank_photos, :through => :categorizations, :source => :categorizable, :source_type => 'ImageBankPhoto'
end