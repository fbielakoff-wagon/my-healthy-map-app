class MapController < ApplicationController
  def index
    @mapbox_token = ENV.fetch("MAPBOX_API_KEY", nil)
    @spots = Spot.all

    if user_signed_in?
      @recent_saved_spots_by_category = current_user.favourites
                                                    .includes(:spot)
                                                    .order(created_at: :desc)
                                                    .limit(8)
                                                    .map(&:spot)
                                                    .group_by(&:category)
                                                    .sort_by { |category, _spots| category }
    end

    return if params[:city].blank?

    @spots = @spots.where("city ILIKE ?", params[:city])

    result = Geocoder.search(params[:city]).first
    @center = { lat: result.coordinates[0], lng: result.coordinates[1], address: result.address } if result
  end

  def nearby
    lat      = params[:lat]
    lng      = params[:lng]
    category = params[:category].presence_in(Spot::CATEGORIES)

    return render json: { error: "lat/lng required" }, status: :bad_request if lat.blank? || lng.blank?

    categories = category ? [category] : Spot::CATEGORIES

    spots = categories.flat_map do |cat|
      NearbySpotsFetcher.new(lat: lat, lng: lng, category: cat).call.to_a
    end

    render json: spots.as_json(
      only: %i[id name category subcategory latitude longitude address source]
    )
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
