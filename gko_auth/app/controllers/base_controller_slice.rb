BaseController.class_eval do
  before_filter :authenticate?, :set_timezone

  protected

  def set_timezone
    if current_user.try(:timezone) && site.timezone.present?
      Time.zone = current_user.timezone
    elsif site.try(:timezone) && site.timezone.present?
      Time.zone = site.timezone
    end
  end

  def authenticate?
    unless local_request? or site.public or user_signed_in?
      redirect_to login_url
    end
  end

end