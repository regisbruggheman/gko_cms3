module Gko::Comment::Paths
  def path_to(page)
    case page
      when 'path/to/comments'
      else
        super
    end
  end
end
World(Gko::Comment::Paths)


