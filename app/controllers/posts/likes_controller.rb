class Posts::LikesController < ApplicationController
  def like
    return head :unprocessable_entity if post.liked_by?(current_user)

    post.mark_as_liked_by(user: current_user)
  end

  def unlike
    return head :unprocessable_entity unless post.liked_by?(current_user)

    post.remove_like_from(user: current_user)

    render :like
  end

  private

  def post
    @post ||= Post.find(params[:id])
  end
  helper_method :post
end
