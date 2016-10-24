class Admin::UsersController < Admin::ResourcesController
  respond_to :html, :js, :json
  # http://spreecommerce.com/blog/2010/11/02/json-hijacking-vulnerability/
  before_filter :check_json_authenticity, :only => :index
  has_scope :with_email, :only => :index
  custom_actions :collection => [:availables]
  custom_actions :resource => [:select, :change_password]
  helper 'admin/users'
  belongs_to :site

  def new
    @user = parent.users.build(:confirmed_at => Time.now)
    respond_with(:admin, current_site, @user)
  end

  def update_password
    if update_resource(resource, resource_params)
      render :action => 'change_password'
    else
      flash[:success] = "Password not updated"
      render :action => 'change_password'
    end
  end

  def destroy
    if !current_user.can_delete?(resource)
      resource.errors[:error] = [:user_cant_be_destroyed]
    else
      resource.destroy
    end
    respond_with(:admin, parent, resource)
  end

  protected

  def json_data
    collection.map { |u| {'id' => u.id, 'name' => u.email} }.to_json
  end

end
