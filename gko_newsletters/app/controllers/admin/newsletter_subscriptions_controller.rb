class Admin::NewsletterSubscriptionsController < Admin::ResourcesController
  belongs_to :site
  respond_to :html, :js

  before_filter :load_site

  def index
    @newsletter_subscriptions = current_site.newsletter_subscriptions.order('newsletter_subscriptions.email ASC')
    respond_with(:admin, current_site, @newsletter_subscriptions)
  end

  def edit
    respond_with(:admin, current_site, @newsletter_subscription)
  end

  def update
    @newsletter_subscription.update_attributes(params[:newsletter_subscription])
    render :action => 'edit'
  end

  def new
    @newsletter_subscription = current_site.newsletter_subscriptions.build
    respond_with(:admin, current_site, @newsletter_subscription)
  end

  def create
    @newsletter_subscription = current_site.newsletter_subscriptions.create(params[:newsletter_subscription])
    respond_with(:admin, current_site, @newsletter_subscription)
  end

  def destroy
    @newsletter_subscription.destroy
    respond_with(:admin, current_site, @newsletter_subscription)
  end

  protected

  def load_site
    @site = Site.find(params[:site_id])
  end


end