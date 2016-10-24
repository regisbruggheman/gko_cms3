class CommentsController < BaseController
  #belongs_to :site#, :polymorphic => true
  def create
    create! do |success, failure|
      success.html do
        @commentable = @comment.commentable
        #if @commentable.section.moderate_comments or @comment.ham?
        #  begin
        #Blog::CommentMailer.notification(@comment, request).deliver
        #  rescue
        #logger.warn "There was an error delivering a blog comment notification.\n#{$!}\n"
        #  end
        #end

        if @commentable.section.moderate_comments
          flash[:success] = t('comments.thank_you_moderated')
          redirect_to url_for([@commentable.section, @commentable])
        else
          flash[:success] = t('thank_you', :scope => 'comments')
          redirect_to url_for([@commentable.section, @commentable])
          #redirect_to blog_post_url(params[:id],
          #                          :anchor => "comment-#{@comment.to_param}")
        end
      end
    end
    #else
    #  render :action => 'show'
    #end
  end

end
