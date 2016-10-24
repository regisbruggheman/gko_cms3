class Redirect < Section
  belongs_to :link, :polymorphic => true
  
  # Overwrite default method as redirect is a child
  def need_slug?
    false
  end
end
