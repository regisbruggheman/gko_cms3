class Admin::DocumentItemsController < Admin::ResourcesController
  include Extensions::Controllers::Cacheable
  nested_belongs_to :site, :document_list
end