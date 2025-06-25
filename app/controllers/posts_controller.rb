class PostsController < ApplicationController
  def index
    @posts = Post.includes(:likes, :user, comments: [ :user ])
      .references(:comments)
      .order(posts: { created_at: :desc }, comments: { created_at: :desc })
  end

  def following
    @posts = Post.includes(:likes, :user, comments: [ :user ])
      .references(:comments)
      .joins(user: :follower_follows)
      .where(user_follows: { user: current_user })
      .order(posts: { created_at: :desc }, comments: { created_at: :desc })

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

  def post
    @post ||= Post.find(params[:id])
  end
  helper_method :post
end
