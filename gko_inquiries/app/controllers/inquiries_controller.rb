class InquiriesController < BaseController

  respond_to :html, :json, :js
  before_filter :set_inquiry, :only => :new
  #before_filter :check_spam, :only => :create

  def create
    create! do |format|
      if resource.errors.empty? && resource.human? #&& resource.ham?
        deliver
        confirm_or_send_copy
        flash[:success] = t('flash.inquiries.create.notice')
        format.html do
          if request.xhr?
            render :layout => false
          else
            redirect_to params[:return_to].present? ? params[:return_to] : :back
          end
        end
      else
        if site.preferred_contact_email.present?
          flash[:error] = t('flash.inquiries.create.alert_with_email', :email => site.preferred_contact_email)
        else
          flash[:error] = t('flash.inquiries.create.alert')
        end
        format.html do
          if request.xhr?
            render :layout => false
          elsif params[:return_to].present?
            redirect_to params[:return_to]
          else
            render :action => 'new'
          end
        end
        #format.js { render :layout => false }
      end
    end
  end

  protected

  def set_inquiry
    @inquiry ||= Inquiry.new(:site => site)
    @inquiry.set_default_values if Rails.env.development?
  end

  def create_resource(object)
    site.inquiry_save_in_database ? super : object.valid?
  end

  def deliver
    InquiryMailer.notification(resource).deliver
  end

  def confirm_or_send_copy
    InquiryMailer.confirmation(resource).deliver
  end
end
