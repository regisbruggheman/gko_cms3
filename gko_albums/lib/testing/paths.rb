module Gko::Album::Paths
  def path_to(page)
    case page
      when 'path/to/album'
      else
        super
    end
  end
end
World(Gko::Album::Paths)


