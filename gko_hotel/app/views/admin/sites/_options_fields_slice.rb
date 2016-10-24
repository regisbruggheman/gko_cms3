require_dependency 'admin/sites/_options_fields'

module Admin::HotelInquiries::OptionsFields
  def to_html
    super
    f.input :hotel_inquiry_recipients
    f.input :table_inquiry_recipients

  end

  Admin::Sites::OptionsFields.send(:include, self)
end