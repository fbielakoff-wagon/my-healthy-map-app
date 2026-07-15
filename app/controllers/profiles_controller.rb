class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @preference = current_user.preference || current_user.build_preference
  end

  def update
  end
end
