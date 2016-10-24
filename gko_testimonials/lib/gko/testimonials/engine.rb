module Gko
  module Testimonials
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_testimonials

      initializer 'gko.testimonials.require_section_types' do
        config.to_prepare { require_dependency 'testimonial_list' }
      end

      initializer "gko.testimonials.register_page_types" do
        Gko::PageTypes.register('testimonial_list', true)
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Testimonials)
      end
    end
  end
end