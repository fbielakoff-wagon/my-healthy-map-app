class MapController < ApplicationController
  def index
    @mapbox_token = ENV.fetch("MAPBOX_API_KEY", nil)
    @spots = Spot.all
  end

  def search
  end
end
