class VisitsByLanguage
  extend Garb::Model

  metrics :visits, :new_visits, :visitors, :page_views, :unique_page_views
  dimensions :language
end