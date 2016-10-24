class Admin::ServicesController < Admin::ContentsController
  belongs_to :site
  belongs_to :service_list
end