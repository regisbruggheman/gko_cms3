require 'active_support/concern'

module Extensions
  module Models
    module Stickable

      extend ActiveSupport::Concern

      included do
        has_many :stickings, :as => :stickable, :dependent => :destroy, :include => :sticker
        has_many :stickers, :through => :stickings

        accepts_nested_attributes_for :stickers, :allow_destroy => false,
          :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
        attr_accessible :stickers_attributes, :sticker_ids_attributes, :sticker_ids
      end

      module ClassMethods

        def sticked(t)
          joins(:stickings => :sticker).where('stickers.id = ?', t)
        end

        def stickers_cache_key(record)
          "#{I18n.locale}/#{name.tableize}/#{record.id}/stickers"
        end

      end
    end # Stickable
  end # Models
end # Extensions
