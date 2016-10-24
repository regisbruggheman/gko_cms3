class UsersController < BaseController
  include Extensions::Controllers::Base

  prepend_before_filter :load_object, :only => [:show, :edit, :update]
  prepend_before_filter :authorize_actions, :only => :new

  def show
    super
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_back_or_default(root_url)
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(params[:user])
      if params[:user][:password].present?
        # this logic needed b/c devise wants to log us out after password changes
        user = User.reset_password_by_token(params[:user])
        sign_in(@user, :event => :authentication, :bypass => true) #!Gko::Auth::Config[:signout_after_password_change])
      end
      redirect_to account_url, :notice => t(:account_updated)
    else
      render :edit
    end

  end

  private
  def load_object
    @user ||= current_user
    authorize! params[:action].to_sym, @user
  end

  def authorize_actions
    #authorize! params[:action].to_sym, User
    authorize! params[:action].to_sym, User.new
  end

end
