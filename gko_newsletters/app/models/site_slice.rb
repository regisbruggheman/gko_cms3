Site.class_eval do
  has_many :newsletter_subscriptions, :dependent => :destroy
  has_many :newsletter_lists, :dependent => :destroy
  has_many :newsletters, :through => :newsletter_lists

  preference :campaign_monitor_api_key, :string, :default => nil
  preference :campaign_monitor_list_id, :string, :default => nil

  attr_accessible :preferred_campaign_monitor_api_key, :preferred_campaign_monitor_list_id

  def campaign_monitor_enabled?
    self.preferred_campaign_monitor_list_id.present? && self.preferred_campaign_monitor_api_key.present?
  end
end
