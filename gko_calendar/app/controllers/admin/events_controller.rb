class Admin::EventsController < Admin::ContentsController
  belongs_to :site
  belongs_to :calendar
end