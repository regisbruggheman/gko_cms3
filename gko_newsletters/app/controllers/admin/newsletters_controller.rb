class Admin::NewslettersController < Admin::ContentsController
  nested_belongs_to :site, :newsletter_list
end