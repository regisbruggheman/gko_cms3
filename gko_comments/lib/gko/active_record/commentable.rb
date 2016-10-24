module Gko
  module Commentable
    def commentable
      unless commentable?
        has_many :commentables, :as => :commentable, :dependent => :destroy
        has_many :comments, :through => :commentables
        accepts_nested_attributes_for :commentables, :allow_destroy => true
        extend ClassMethods
      end
    end

    def commentable?
      singleton_class.included_modules.include?(ClassMethods)
    end

    module ClassMethods
      def commented(comment_id)
        comment = Comment.find(comment_id)
        comment_ids = comment.self_and_descendants.map(&:id)
        includes(:commentables).where(:commentables => {:comment_id => comment_ids})
      end
    end

    ActiveRecord::Base.extend(self)
  end
end
