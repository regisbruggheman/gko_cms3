class NewsletterSubscription < ActiveRecord::Base
  belongs_to_site
  validates_presence_of :email, :message => 'Please enter your email address first.'
  validates_uniqueness_of :email, :message => 'That email is already on the list.'
  validates_format_of :email,
                      :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
                      :message => 'That email address doesn\'t look right.'

  attr_accessible :email

  after_save :add_to_campaign_monitor, :if => "site.campaign_monitor_enabled?"

  private

  def add_to_campaign_monitor
    list_id = site.preferred_campaign_monitor_list_id
    CreateSend.api_key site.preferred_campaign_monitor_api_key
    #cl = CreateSend::CreateSend.new
    #cl.apikey("http://account.stbarth-emailing.com", "joufdesign", "rgsbrgghmn72")
    #Rails.logger.info "ZZZZZZ CreateSend.api_key #{CreateSend::Subscriber.add(list_id, email, "", [], true)}"
  end
end
