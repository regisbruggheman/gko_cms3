# Common behaviour that we want included in all gko engines

module Gko
  module Engine
    extend ActiveSupport::Concern  
    included do 
      initializer "gko.#{engine_name}.require_patches" do |app|
        Dir[root.join('lib/patches/**/*.rb')].each { |patch| require patch }
      end
    end
  end
end
