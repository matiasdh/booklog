class PostsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
  end

  def create
    @post = current_user.posts.create!(post_params)
  end

  def destroy
  end

  private

  def post_params
    params.expect(post: [ :body ])
  end
end
