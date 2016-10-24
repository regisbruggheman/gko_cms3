class HotelInquiriesController < InquiriesController
  before_filter :set_inquiry, :only => :new
  #before_filter :clean_dates, :only => :create

  protected

  def set_inquiry
    @hotel_inquiry ||= HotelInquiry.new(:site => site)
    @hotel_inquiry.set_default_values if Rails.env.development?
  end

  def deliver
    InquiryMailer.hotel_notification(resource).deliver
  end

  #private

  # to do put in base_controller as helper
  #def clean_dates
  #  if params.has_key?(:hotel_inquiry)
  #    params[:hotel_inquiry][:start_date] = Date.civil(
  #        params[:hotel_inquiry].delete(:'start_date(1i)').to_i,
  #        params[:hotel_inquiry].delete(:'start_date(2i)').to_i,
  #        params[:hotel_inquiry].delete(:'start_date(3i)').to_i)

  #    params[:hotel_inquiry][:end_date] = Date.civil(
  #        params[:hotel_inquiry].delete(:'end_date(1i)').to_i,
  #        params[:hotel_inquiry].delete(:'end_date(2i)').to_i,
  #        params[:hotel_inquiry].delete(:'end_date(3i)').to_i)
  #  end
  ##end

end
