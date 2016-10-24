%w(core).each do |engine|
  require "gko_#{engine}"
end