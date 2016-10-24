module Gko::Press::Paths
  def path_to(page)
    case page
      when 'path/to/press'
      else
        super
    end
  end
end
World(Gko::Press::Paths)


