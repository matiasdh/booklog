class Users::FollowController < ApplicationController
  before_action :ensure_turbo_stream_request!, only: %i[ create destroy ]

  def create
    current_user.follow(user)
    user.reload # reload user to reload counter cache counts
  end

  def destroy
    current_user.unfollow(user)
    user.reload # reload user to reload counter cache counts
  end

  private

  def user
    @user ||= User.find(params[:id])
  end
  helper_method :user
end
