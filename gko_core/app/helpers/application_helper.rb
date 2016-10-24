module ApplicationHelper
 def ampm(hours, separator=":")
    splitter = hours.split(separator)
 end

 def with_format(format, &block)
   old_formats = formats
   self.formats = [format]
   block.call
   self.formats = old_formats
   nil
 end
 
 def image_url(source)
   "#{root_url}#{image_path(source)}"
 end
end