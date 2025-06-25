class Users::FollowController < ApplicationController
  def create
    current_user.follow(user)
  end

  def destroy
    current_user.unfollow(user)
  end

  private

  def user
    @user ||= User.find(params[:id])
  end
  helper_method :user
end
