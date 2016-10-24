module Admin
  module SectionsHelper
    
    #TODO : Put in Section Model
    def accept_child_section?(node)
      node.root? || node.is_a?(Page)
    end
  end

end
