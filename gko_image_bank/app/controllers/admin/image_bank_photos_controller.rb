class Admin::ImageBankPhotosController < Admin::ResourcesController
  nested_belongs_to :site, :image_bank
  respond_to :html
end