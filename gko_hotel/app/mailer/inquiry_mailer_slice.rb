InquiryMailer.class_eval do
  def hotel_notification(inquiry)
    @inquiry = inquiry
    mail(:to => inquiry.site.hotel_inquiry_recipients,
         :subject => t(:'inquiry_mailer.hotel_notification.subject'),
         :from => "\"#{inquiry.site.title}\" <#{@inquiry.email}>",
         :reply_to => @inquiry.email) do |format|
      format.html
    end
  end

  def table_notification(inquiry)
    @inquiry = inquiry
    mail(:to => inquiry.site.table_inquiry_recipients,
         :subject => t(:'inquiry_mailer.table_notification.subject'),
         :from => "\"#{inquiry.site.title}\" <#{@inquiry.email}>",
         :reply_to => @inquiry.email) do |format|
      format.html
    end
  end
end