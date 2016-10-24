module Gko::Sticker::Paths
  def path_to(page)
    case page
      when 'path/to/sticker'
      else
        super
    end
  end
end
World(Gko::Sticker::Paths)


