class Home < Section
  
  before_validation :set_title, :unless => "title.present?"
  before_validation :set_name, :unless => "name.present?"
  before_validation :set_template, :unless => "template.present?"

  # Get public url for the specified locale
  def public_url(locale=nil)
    locale ||= ::Globalize.locale
    u = []
    u.unshift(locale.to_s) if (locale.to_sym != site.default_locale.to_sym)
    u = u.join('/')
    u = '/' + u
    u
  end
  
  protected
  
  def set_title
    self.title = "home"
  end

  def set_name
    self.name = "main"
  end
  
  def set_template
    self.template = "home"
  end
end