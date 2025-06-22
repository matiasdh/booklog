class Posts::CommentsController < ApplicationController
  before_action :ensure_turbo_stream_request!, only: %i[ create ]

  def create
    @comment = post.comments.new(comment_params)
    @comment.user = current_user

   if @comment.save
    render :create
   else
    render :new, status: :unprocessable_entity
   end
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
