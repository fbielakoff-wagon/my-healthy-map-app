class MapController < ApplicationController
  def index
    @mapbox_token = ENV.fetch("MAPBOX_API_KEY", nil)
    @spots = Spot.all

    return if params[:city].blank?

    @spots = @spots.where("city ILIKE ?", params[:city])

    result = Geocoder.search(params[:city]).first
    @center = { lat: result.coordinates[0], lng: result.coordinates[1], address: result.address } if result
  end

  def search
    @mapbox_token = ENV.fetch("MAPBOX_API_KEY", nil)
    @spots = Spot.all

    result = Geocoder.search(params[:address]).first

    if result
      latitude, longitude = result.coordinates # Geocoder returns [lat, lng]
      @center = { lat: latitude, lng: longitude, address: result.address }
    else
      flash.now[:alert] = "Couldn't find \"#{params[:address]}\" — showing the default map instead."
    end

    render :index
  end
end
