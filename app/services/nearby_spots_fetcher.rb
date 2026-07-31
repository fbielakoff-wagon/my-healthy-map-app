require "net/http"

class NearbySpotsFetcher
  CACHE_TTL      = 24.hours
  BASE           = "https://api.mapbox.com/search/searchbox/v1".freeze
  RADIUS_METERS  = 3_000
  PER_CATEGORY   = 10
  PER_KEYWORD    = 5
  MAX_KEYWORDS   = 4

  def initialize(lat:, lng:, category:)
    @lat      = lat.to_f
    @lng      = lng.to_f
    @category = category
  end

  def call
    return cached if cache_fresh?

    fetch_and_store
    cached
  rescue StandardError => e
    Rails.logger.error("[NearbySpotsFetcher] #{e.class}: #{e.message}")
    cached
  end

  private

  def tile = "#{@lat.round(2)},#{@lng.round(2)}"

  def cached
    Spot.where(category: @category)
        .where(cache_tile: [tile, nil])
        .near([@lat, @lng], RADIUS_METERS / 1000.0, units: :km)
        .limit(60)
  end

  def cache_fresh?
    Spot.from_api
        .where(category: @category, cache_tile: tile)
        .where("fetched_at > ?", CACHE_TTL.ago)
        .exists?
  end

  def fetch_and_store
    results  = HealthyCategories.all_for(@category)
                                .flat_map { |id| category_search(id) }
    results += HealthyCategories.keywords_for(@category)
                                .sample(MAX_KEYWORDS)
                                .flat_map { |kw| keyword_search(kw) }

    results.uniq { |f| f.dig("properties", "mapbox_id") }
           .each { |f| upsert(f) }
  end

  def category_search(canonical_id)
    get("#{BASE}/category/#{canonical_id}", {
          proximity: "#{@lng},#{@lat}",
          limit: PER_CATEGORY,
          language: "en"
        })
  end

  def keyword_search(query)
    get("#{BASE}/forward", {
          q: query,
          proximity: "#{@lng},#{@lat}",
          limit: PER_KEYWORD,
          types: "poi",
          language: "en"
        })
  end

  def get(url, params)
    uri = URI(url)
    uri.query = URI.encode_www_form(params.merge(access_token: token))
    res = Net::HTTP.get_response(uri)
    return [] unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body).fetch("features", [])
  rescue StandardError => e
    Rails.logger.warn("[NearbySpotsFetcher] API call failed for #{url}: #{e.message}")
    []
  end

  def token = ENV.fetch("MAPBOX_API_KEY")

  def upsert(feature)
    props  = feature["properties"] || {}
    coords = feature.dig("geometry", "coordinates")
    return if coords.blank? || props["name"].blank?

    lng, lat = coords
    return if distance_m(lat, lng) > RADIUS_METERS

    spot = Spot.find_or_initialize_by(external_id: props["mapbox_id"])
    spot.assign_attributes(
      name: props["name"],
      description: props["poi_category"]&.join(", ").presence || props["place_formatted"],
      category: @category,
      subcategory: props["poi_category"]&.first,
      address: props["full_address"] || props["place_formatted"],
      city: extract_city(props),
      latitude: lat,
      longitude: lng,
      source: "mapbox",
      cache_tile: tile,
      fetched_at: Time.current
    )
    return if spot.save

    Rails.logger.warn("[Fetcher] rejected #{props['name']}: #{spot.errors.full_messages.join(', ')}")
  end

  def extract_city(props)
    ctx = props["context"] || {}
    ctx.dig("place", "name") ||
      ctx.dig("locality", "name") ||
      ctx.dig("district", "name") ||
      ctx.dig("region", "name") ||
      reverse_geocoded_city
  end

  def reverse_geocoded_city
    @reverse_geocoded_city ||= Geocoder.search([@lat, @lng]).first&.city
  end

  def distance_m(lat, lng)
    Geocoder::Calculations.distance_between(
      [@lat, @lng], [lat, lng], units: :km
    ) * 1000
  end
end
