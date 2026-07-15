class MapController < ApplicationController
  def index
    @mapbox_token = ENV.fetch("MAPBOX_API_KEY", nil)
  end

  def search
  end
end
