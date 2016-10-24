require 'logger'
Rails.logger = Logger.new("#{Rails.root}/log/#{ENV['RAILS_ENV']}.log", 10, 1.megabyte)
