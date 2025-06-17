class UsersController < ApplicationController
  def show
  end

  def edit
  end

  def update
    if user.update(user_params)
      render turbo_stream: helpers.tag.turbo_stream(action: "redirect", location: user_path(user))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username)
    end

    def user
      @user ||= User.find(params[:id])
    end
    helper_method :user
end
