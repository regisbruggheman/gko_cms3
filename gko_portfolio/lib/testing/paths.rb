module Gko::Gallery::Paths
  def path_to(page)
    case page
      when 'path/to/portfolio'
      else
        super
    end
  end
end
World(Gko::Gallery::Paths)


