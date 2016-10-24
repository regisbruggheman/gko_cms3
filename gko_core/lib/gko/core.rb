module Gko

  autoload :Plugin,  'gko/plugin'
  autoload :Plugins, 'gko/plugins'
  autoload :PageType,  'gko/page_type'
  autoload :PageTypes, 'gko/page_types'
  
  module Core
    require 'gko/core/engine'
    require 'gko/core/configuration'
    require 'gko/core/file_utilz'
    require 'gko/core/routing_filters/shared'
    require 'gko/core/routing_filters/section_path'
    require 'gko/core/routing_filters/section_root'
    require 'gko/core/routing_filters/localize'
    require 'gko/core/routing_filters/paginate'
    require 'gko/core/active_record/has_options'
    require 'gko/core/active_record/has_thumbnail'
    require 'gko/core/active_record/has_one_default'
    require 'gko/core/active_record/sortable'
    require 'gko/core/active_record/belongs_to_site'
    require 'gko/core/active_model/validations/email_validator'
    require 'gko/core/active_model/validations/url_validator'
    require 'gko/core/caching/sweeper'
    require 'gko/core/carrierwave'
    require 'gko/core/will_paginate/bootstrap_pagination'
    require 'gko/core/mail_settings'

    autoload :Dragonfly, 'gko/core/dragonfly'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end