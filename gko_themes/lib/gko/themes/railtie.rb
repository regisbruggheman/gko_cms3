# encoding: utf-8
module Gko
  module Themes
    class Railtie < ::Rails::Railtie

      config.themes_for_rails = ActiveSupport::OrderedOptions.new

      config.to_prepare do
        Gko::Themes::Railtie.config.themes_for_rails.each do |key, value|
          Gko::Themes.config.send "#{key}=".to_sym, value
        end

        # Adding theme stylesheets path to sass, automatically. 
        Gko::Themes.add_themes_path_to_sass if Gko::Themes.config.use_sass?

        ActiveSupport.on_load(:action_view) do
          include Gko::Themes::ActionView
        end

        ActiveSupport.on_load(:action_controller) do
          include Gko::Themes::ActionController
        end

        ActiveSupport.on_load(:action_mailer) do
          include Gko::Themes::ActionMailer
        end
      end

      rake_tasks do
        load "tasks/themes.rake"
      end
    end
  end
end