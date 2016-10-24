class ImageAssignmentSweeper < Gko::Sweeper
  observe ImageAssignment

  def after_save(image_assignment)
    expire_image_assignment(image_assignment)
  end

  def after_destroy(image_assignment)
    expire_image_assignment(image_assignment)
  end

  def expire_image_assignment(image_assignment)
    attachable = image_assignment.attachable

    if attachable.is_a?(Content)
      expire_content_cache(attachable)
    elsif attachable.is_a?(Section)
      expire_section_cache(attachable)
    end
  end
end
