class UsersController < ApplicationController
  def show
  end

  def edit
  end

  def update
    if user.update(user_params)
      render :update
    else
      render :edit, status: :unprocessable_entity
    end
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
