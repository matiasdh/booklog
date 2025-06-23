class PostsController < ApplicationController
  def index
    @posts = Post.with_feed
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      render :create
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
