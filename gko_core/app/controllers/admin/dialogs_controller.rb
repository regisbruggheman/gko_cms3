class Admin::DialogsController < Admin::BaseController
  layout 'admin_dialog'

  def show
    #request.referer.match "/site\/[0-9]"
    if (@dialog_type = params[:id].try(:downcase)) #id of the frame send from wymeditor
      url_params = params.reject { |key, value| key =~ /(action)|(controller)/ }
      @iframe_src = if @dialog_type == 'image'
                      insert_admin_site_images_url(current_site, :dialog => true, :app_dialog => true)
                    elsif @dialog_type == 'link'
                      link_to_admin_pages_dialogs_url(:dialog => true)
                    end
      render :layout => false
    else
      render :nothing => true
    end
  end

  def from_dialog?
    true
  end


end
