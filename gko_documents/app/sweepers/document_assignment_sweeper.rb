class DocumentAssignmentSweeper < Gko::Sweeper
  observe DocumentAssignment

  def after_save(document_assignment)
    expire_document_assignment(document_assignment)
  end

  def after_destroy(document_assignment)
    expire_document_assignment(document_assignment)
  end

  def expire_document_assignment(document_assignment)
    attachable = document_assignment.attachable

    if attachable.is_a?(Content)
      expire_content_cache(attachable)
    elsif attachable.is_a?(Section)
      expire_section_cache(attachable)
    end
  end
end