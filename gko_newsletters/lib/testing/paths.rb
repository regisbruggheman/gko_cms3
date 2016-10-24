module Gko::Newsletters::Paths
  def path_to(page)
    case page
      when 'path/to/newsletters'
      else
        super
    end
  end
end
World(Gko::Newsletters::Paths)


