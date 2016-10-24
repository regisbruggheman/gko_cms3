class EventsController < BaseController
  include Extensions::Controllers::BelongsToSection
  respond_to :html, :js, :atom
  belongs_to :calendar
end
