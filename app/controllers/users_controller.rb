class UsersController < ApplicationController
  def show
  end

  # GET /users/1/edit
  def edit
  end


  # PATCH/PUT /users/1 or /users/1.json
  def update
    current_user.update!(user_params)
  end



  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
