class TwitsController < BaseController
  
  include Extensions::Controllers::BelongsToSection
  actions :index, :show
  respond_to :html
  belongs_to :twit_list

  protected

  def collection
    @twits ||= end_of_association_chain.with_globalize.live.order("twits.published_at ASC")
    @twits ? @twits.paginate(:page => params[:page], :per_page => per_page) : []
  end

end