class Page < Section
  #has_one :content, :foreign_key => 'section_id', :inverse_of => :section, :dependent => :destroy, :default => :build_default_content
  #accepts_nested_attributes_for :content

  #def build_default_content
  #  build_content(
  #    :site => site,
  #    :body => body, 
  #    :title => title, 
  #    :meta_title => meta_title,
  #    :meta_description => meta_description,
  #    :slug => slug)
  #end

end