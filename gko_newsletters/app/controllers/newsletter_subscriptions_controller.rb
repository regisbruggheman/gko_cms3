class NewsletterSubscriptionsController < BaseController

  respond_to :html, :json

  def new
    @newsletter_subscription = site.newsletter_subscriptions.build
    respond_with(@newsletter_subscription)
  end

  def create
    @newsletter_subscription = site.newsletter_subscriptions.new(params[:newsletter_subscription])
    if @newsletter_subscription.save  
      flash[:success] = "Successfully created subscription."  
    end
    respond_with(@newsletter_subscription)
  end

  def destroy
    @newsletter_subscription.destroy
    respond_with(@newsletter_subscription)
  end

end