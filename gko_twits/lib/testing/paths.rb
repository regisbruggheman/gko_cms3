module Gko::Twits::Paths
  def path_to(page)
    case page
      when 'path/to/twits'
      else
        super
    end
  end
end
World(Gko::Twits::Paths)


