Geocoder.configure(
  lookup: :mapbox,
  api_key: ENV.fetch("MAPBOX_API_KEY", nil),
  units: :km
)
