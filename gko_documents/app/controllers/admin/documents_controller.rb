class Admin::DocumentsController < Admin::ResourcesController
  belongs_to :site
  respond_to :html
  custom_actions :collection => :insert
  has_scope :with_title, :with_document_name, :only => :index
  before_filter :load_attachable, :only => [:new, :insert, :batch]
  before_filter :set_insert, :only => [:insert]
  
  def set_insert
    params[:insert] = true
  end

  def filter_collection(col)
    if @attachable && @attachable.documents.any?
      ids = @attachable.documents.map(&:id)
      col = col.where("documents.id NOT in (?)", ids)
    end
    return col.order('documents.created_at DESC')
  end

  private

  def load_attachable
    if params[:attachable_id].present? && params[:attachable_type].present?
      @attachable = params[:attachable_type].camelize.constantize.find(params[:attachable_id])
    end
  end
end
