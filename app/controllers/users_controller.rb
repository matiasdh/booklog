class UsersController < ApplicationController
  def show
  end

  # GET /users/1/edit
  def edit
  end


  # PATCH/PUT /users/1 or /users/1.json
  def update
    if current_user.update(user_params)
      render turbo_stream: helpers.tag.turbo_stream(action: "redirect", location: profile_path), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end



  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username)
    end
end
