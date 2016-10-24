module Gko::Inquiry::Paths
  def path_to(page)
    case page
      when 'path/to/inquiry'
      else
        super
    end
  end
end
World(Gko::Inquiry::Paths)


