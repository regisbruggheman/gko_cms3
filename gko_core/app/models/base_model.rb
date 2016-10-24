require 'active_record'

module Gko
  module Core
    class BaseModel < ActiveRecord::Base

      self.abstract_class = true

    end
  end
end