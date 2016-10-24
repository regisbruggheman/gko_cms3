class TableInquiriesController < InquiriesController
  
  before_filter :set_inquiry, :only => :new

  protected
  
  def set_inquiry
    @table_inquiry ||= TableInquiry.new(:site => site, :date => Date.today)
    @table_inquiry.set_default_values if Rails.env.development?
  end

  def deliver
    InquiryMailer.table_notification(resource).deliver
  end
  
  # to do put in base_controller as helper
  #def clean_dates
  #  if params.has_key?(:table_inquiry)
  #    params[:table_inquiry][:date] = Date.civil(
  #        params[:table_inquiry].delete(:'date(1i)').to_i,
  #        params[:table_inquiry].delete(:'date(2i)').to_i,
  #        params[:table_inquiry].delete(:'date(3i)').to_i)
  #  end
  #end
end
