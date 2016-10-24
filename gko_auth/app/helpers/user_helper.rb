module UserHelper

  def sign_in_link
    capture { link_to(t(:'user.links.sign_in'), new_session_path(:user), :class => :sign_in) }
  end

  def sign_up_link(options={}, html_options={})
    capture { link_to(t(:'user.links.sign_up'), new_registration_path(:user, options), {:class => :sign_up}.merge(html_options)) }
  end

  def forgot_password_link
    capture { link_to(t(:'user.links.forgot_password'), new_password_path(:user), :class => :forgot_password) }
  end

  def resend_confirmation_link
    capture { link_to(t(:'user.links.resend_confirmation'), new_confirmation_path(:user), :class => :resend_confirmation) }
  end

  def resend_unlock_link
    capture { link_to(t(:'user.links.resend_unlock'), new_unlock_path(:user), :class => :resend_unlock) }
  end

  def sign_out_link
    capture { link_to(t(:'user.links.sign_out', :user => current_user.email), destroy_user_session_path, :class => :sign_out) }
  end

  def profile_link
    capture { link_to(t(:'user.links.view_profile'), profile_path, :class => :profile) }
  end

end