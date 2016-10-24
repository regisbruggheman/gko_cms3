class ThemesController < BaseController
  layout 'preview'
  
  def preview
   @theme = params[:theme].presence ? Theme.find_by_name(params[:theme]) : Theme.first
  end

  
end