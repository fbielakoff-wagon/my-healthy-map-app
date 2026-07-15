class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favourite_spots = current_user.favourite_spots
  end

  def create
    @spot = Spot.find(params[:spot_id])
    @favourite = current_user.favourites.new(spot: @spot)

    if @favourite.save
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
