class PostsController < ApplicationController
  def index
    @posts = Post.includes(:likes, :user, comments: [ :user ]).references(:comments).order(posts: { created_at: :desc }, comments: { created_at: :desc })
  end

  def show
  end

  def create
    @post = current_user.posts.create!(post_params)
  end

  def like
    return head :unprocessable_entity if post.liked_by?(current_user)

    post.mark_as_liked_by(user: current_user)
  end

  def unlike
    return head :unprocessable_entity unless post.liked_by?(current_user)

    post.remove_like_from(user: current_user)

    render :like
  end

  def destroy
  end

  private

  def post_params
    params.expect(post: [ :body ])
  end

  def post
    @post ||= Post.find(params[:id])
  end
  helper_method :post
end
