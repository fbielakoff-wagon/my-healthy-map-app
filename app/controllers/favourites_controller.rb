class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favourite_spots_by_category = current_user.favourites
                                               .includes(:spot)
                                               .map(&:spot)
                                               .group_by(&:category)
                                               .sort_by { |category, _spots| category }
  end

  def create
    @spot = Spot.find(params[:spot_id])
    @favourite = current_user.favourites.find_or_initialize_by(spot: @spot)

    if @favourite.persisted?
      redirect_to @spot, notice: "This spot is already in your favourites."
    elsif @favourite.save
      redirect_to @spot, notice: "Spot added to your favourites."
    else
      redirect_to @spot, alert: "This spot could not be added."
    end
  end

  def destroy
    @favourite = current_user.favourites.find(params[:id])
    @favourite.destroy

    redirect_to favourites_path, notice: "Spot removed from your favourites."
  end
end
