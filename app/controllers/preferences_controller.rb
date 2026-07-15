class PreferencesController < ApplicationController
  before_action :authenticate_user!

  def update
    @preference = current_user.preference || current_user.build_preference

    if @preference.update(preference_params)
      redirect_to edit_profile_path, notice: "Preferences updated."
    else
      redirect_to edit_profile_path, alert: "Preferences could not be updated."
    end
  end

  private

  def preference_params
    params.require(:preference).permit(:categories)
  end
end
