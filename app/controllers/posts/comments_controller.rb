class Posts::CommentsController < ApplicationController
  def create
    @comment = post.comments.new(comment_params)
    @comment.user = current_user

   @comment.save!
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def post
    @post ||= Post.find(params[:id])
  end
  helper_method :post
end
