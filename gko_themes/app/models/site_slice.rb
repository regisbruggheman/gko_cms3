Site.class_eval do
  belongs_to :theme

  def has_theme?
    theme.presence
  end

  def theme_name
    return self.theme.name if has_theme?
  end

  def theme_path
    Rails.root.join("themes", "#{theme_name}").to_s if has_theme?
  end

end
                