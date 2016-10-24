module Admin::UsersHelper

  def list_roles(user)
    # while testing spree-core itself user model does not have method roles
    user.respond_to?(:roles) ? user.roles.collect { |role| role.name }.join(", ") : []
  end

  # Show the button only if user is allowed
  def icon_to_change_password(user)
    if (user_master? || current_user == user)
      icon_to(change_password_admin_site_user_path(user.site, user), "key",
              :title => t("admin.users.actions.change_password"),
              :class => "tooltip")
    end
  end

  # Show the button only if user is allowed 
  def btn_to_change_password(user, options={})
    options[:icon] = "key"
    if (user_master? || current_user == user)
      btn_to(t("admin.users.actions.change_password"),
             change_password_admin_site_user_path(user.site, user, :method => :get), options)
    end
  end
end