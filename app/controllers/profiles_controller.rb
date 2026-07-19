class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @preference = current_user.preference || current_user.build_preference
  end

  def update
    if current_user.update(profile_params)
      redirect_to edit_profile_path, notice: "Your profile has been updated."
    else
      @preference = current_user.preference || current_user.build_preference
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :city)
  end
end
