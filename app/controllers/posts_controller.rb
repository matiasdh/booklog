class PostsController < ApplicationController
  def index
    @pagy, @posts = pagy(Post.with_feed)
  end

  def following
    @pagy, @posts = pagy(Post.for_user(current_user).with_feed)

    render :index
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
