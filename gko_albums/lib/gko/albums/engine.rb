module Gko
  module Albums
    class Engine < ::Rails::Engine
      include Gko::Engine
      engine_name :gko_albums
      initializer 'gko.albums.require_section_types' do
        config.to_prepare { require_dependency 'album_list' }
      end
      
      initializer "gko.albums.register_page_types" do
        Gko::PageTypes.register('album_list', true)
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Albums)
      end
    end
  end
end