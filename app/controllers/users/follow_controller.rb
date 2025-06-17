class Users::FollowController < ApplicationController
  def create
    user.follow(current_user)
  end

  def destroy
    user.unfollow(current_user)
  end

  private

  def user
    @user ||= User.find(params[:id])
  end
  helper_method :user
end
