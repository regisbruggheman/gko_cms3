module DevicesHelper
  
  # Use mobvious to get the user's device type, it will return mobile, tablet or desktop
  def device_type
    return request.env['mobvious.device_type']
  end

  def is_mobile_device?
    return request.env['mobvious.device_type'] == :mobile
  end

  def is_tablet_device?
    return request.env['mobvious.device_type'] == :tablet
  end

  def is_desktop_device?
    return request.env['mobvious.device_type'] == :desktop
  end

end