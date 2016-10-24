class ImageBankPhotosController < BaseController
  include Extensions::Controllers::BelongsToSection
  actions :index
  respond_to :html, :js
  belongs_to :image_bank
  has_scope :with_category, :only => :index

  protected
  
  #def layout?
  #  parent.layout
  #end
  
  def load_resources
    end_of_association_chain
  end
end