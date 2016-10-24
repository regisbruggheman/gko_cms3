module Gko::Calendar::Paths
  def path_to(page)
    case page
      when 'path/to/events'
      else
        super
    end
  end
end
World(Gko::Calendar::Paths)


