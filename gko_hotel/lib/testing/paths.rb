module Gko::Hotel::Paths
  def path_to(page)
    case page
      when 'path/to/hotel'
      else
        super
    end
  end
end
World(Gko::Hotel::Paths)


