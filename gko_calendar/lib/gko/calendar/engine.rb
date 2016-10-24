module Gko
  module Calendar
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_calendar

      initializer 'gko.calendar.require_section_types' do
        config.to_prepare { require_dependency 'calendar' }
      end
      
      initializer "gko.calendar.register_page_types" do
        Gko::PageTypes.register('calendar', true)
      end
      
      initializer 'gko.calendar.configure_routing_filters' do
        RoutingFilter::SectionRoot.anchors << '\d{4}'
      end

      config.after_initialize do
        Gko.register_engine(Gko::Calendar)
      end

    end
  end
end