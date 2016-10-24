class FastController < ActionController::Base

  def wymiframe
    render :template => "layouts/wymiframe", :layout => false
  end

end