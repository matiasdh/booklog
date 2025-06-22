class UsersController < ApplicationController
  def show
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end

  def user
    @user ||= User.find(params[:id])
  end
  helper_method :user
end
