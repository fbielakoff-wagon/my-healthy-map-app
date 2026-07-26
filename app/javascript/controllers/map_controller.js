import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

const CATEGORY_COLORS = {
  food: "#ec7964",
  fitness: "#93bec2",
  wellness: "#b5a8d1"
}

const CATEGORY_EMOJI = {
  food: "🥗",
  fitness: "💪",
  wellness: "🧘"
}

// Haversine formula — straight-line ("as the crow flies") distance between
// two lat/lng points, in km. Good enough for "roughly how far is this spot",
// not turn-by-turn walking/driving distance.
function distanceKm(lat1, lng1, lat2, lng2) {
  const toRad = (deg) => (deg * Math.PI) / 180
  const earthRadiusKm = 6371

  const dLat = toRad(lat2 - lat1)
  const dLng = toRad(lng2 - lng1)
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLng / 2) ** 2

  return earthRadiusKm * 2 * Math.asin(Math.sqrt(a))
}

function formatDistance(km) {
  return km < 1 ? `${Math.round(km * 1000)} m away` : `${km.toFixed(1)} km away`
}

export default class extends Controller {
  static values = { token: String, spots: Array, center: Object }
  static targets = ["mapContainer", "filterButton", "addressInput", "suggestions"]

  connect() {
    mapboxgl.accessToken = this.tokenValue

    const hasSearchCenter = this.hasCenterValue && Object.keys(this.centerValue).length > 0
    const initialCenter = hasSearchCenter
      ? [this.centerValue.lng, this.centerValue.lat]
      : [-0.0778, 51.5074]

    this.map = new mapboxgl.Map({
      container: this.mapContainerTarget,
      style: "mapbox://styles/mapbox/streets-v12",
      center: initialCenter,
      zoom: 12
    })

    this.addMarkers()

    if (hasSearchCenter) {
      this.showSearchMarker(this.centerValue.lng, this.centerValue.lat, this.centerValue.address)
    }

    this.locateAndLoad()
  }

  locateAndLoad() {
    if (!navigator.geolocation) return

    navigator.geolocation.getCurrentPosition(
      async ({ coords }) => {
        const { latitude: lat, longitude: lng } = coords
        this.userLocation = { lat, lng }

        this.map.flyTo({ center: [lng, lat], zoom: 14 })

        // The seeded-spot markers were already built in addMarkers(), before
        // we knew where the user is — rebuild their popups now that we do.
        this.refreshDistances()

        const res = await fetch(`/map/nearby?lat=${lat}&lng=${lng}`)
        if (!res.ok) return

        const spots = await res.json()
        this.renderApiMarkers(spots)
      },
      () => console.log("Geolocation declined — showing seeded spots")
    )
  }

  refreshDistances() {
    this.markers.forEach(({ marker, spot }) => {
      marker.setPopup(new mapboxgl.Popup().setDOMContent(this.buildPopup(spot)))
    })
  }

  renderApiMarkers(spots) {
    spots.forEach((spot) => {
      const el = document.createElement("div")
      el.className = "spot-marker"
      el.style.backgroundColor = CATEGORY_COLORS[spot.category] || "#6c757d"
      el.textContent = CATEGORY_EMOJI[spot.category] || "📍"

      new mapboxgl.Marker({ element: el })
        .setLngLat([spot.longitude, spot.latitude])
        .setPopup(new mapboxgl.Popup().setDOMContent(this.buildPopup(spot)))
        .addTo(this.map)
    })
  }

  addMarkers() {
    this.markers = this.spotsValue.map((spot) => {
      const el = document.createElement("div")
      el.className = "spot-marker"
      el.style.backgroundColor = CATEGORY_COLORS[spot.category] || "#6c757d"
      el.textContent = CATEGORY_EMOJI[spot.category] || "📍"

      const marker = new mapboxgl.Marker({ element: el })
        .setLngLat([spot.longitude, spot.latitude])
        .setPopup(new mapboxgl.Popup().setDOMContent(this.buildPopup(spot)))
        .addTo(this.map)

      return { marker, category: spot.category, id: spot.id, spot }
    })
  }

  buildPopup(spot) {
    const wrapper = document.createElement("div")
    wrapper.className = "spot-popup"

    const emoji = document.createElement("div")
    emoji.className = "spot-popup__emoji"
    emoji.textContent = CATEGORY_EMOJI[spot.category] || "📍"

    const name = document.createElement("h3")
    name.className = "spot-popup__title"
    name.textContent = spot.name

    wrapper.appendChild(emoji)
    wrapper.appendChild(name)

    if (this.userLocation) {
      const km = distanceKm(this.userLocation.lat, this.userLocation.lng, spot.latitude, spot.longitude)
      const distance = document.createElement("p")
      distance.className = "spot-popup__distance"
      distance.textContent = formatDistance(km)
      wrapper.appendChild(distance)
    }

    const link = document.createElement("a")
    link.className = "spot-popup__link"
    link.href = `/spots/${spot.id}`
    link.textContent = "View spot →"
    wrapper.appendChild(link)

    return wrapper
  }

  filterByCategory(event) {
    const category = event.currentTarget.dataset.category

    this.markers.forEach(({ marker, category: markerCategory }) => {
      const visible = category === "all" || markerCategory === category
      marker.getElement().style.display = visible ? "" : "none"
    })

    this.filterButtonTargets.forEach((button) => {
      button.classList.toggle("chip--active", button === event.currentTarget)
    })
  }

  suggestLocations() {
    clearTimeout(this.suggestTimeout)
    this.suggestTimeout = setTimeout(() => this.fetchSuggestions(), 300)
  }

  async fetchSuggestions() {
    const query = this.addressInputTarget.value.trim()

    if (query.length < 3) {
      this.suggestionsTarget.innerHTML = ""
      return
    }

    const spotMatches = this.matchingSpots(query)
    const addressMatches = await this.fetchAddressSuggestions(query)

    this.renderSuggestions([...spotMatches, ...addressMatches])
  }

  matchingSpots(query) {
    const lowerQuery = query.toLowerCase()

    return this.spotsValue
      .filter((spot) => spot.name.toLowerCase().includes(lowerQuery))
      .map((spot) => ({
        type: "spot",
        label: spot.name,
        emoji: CATEGORY_EMOJI[spot.category] || "📍",
        lngLat: [spot.longitude, spot.latitude],
        spotId: spot.id
      }))
  }

  async fetchAddressSuggestions(query) {
    const { lng, lat } = this.map.getCenter()
    const url = "https://api.mapbox.com/geocoding/v5/mapbox.places/" +
      `${encodeURIComponent(query)}.json` +
      `?access_token=${this.tokenValue}&autocomplete=true&limit=5&proximity=${lng},${lat}&types=address,poi`

    const response = await fetch(url)
    const data = await response.json()

    return (data.features || []).map((feature) => ({
      type: "address",
      label: feature.place_name,
      emoji: "📍",
      lngLat: feature.center
    }))
  }

  renderSuggestions(suggestions) {
    this.currentSuggestions = suggestions
    this.suggestionsTarget.innerHTML = ""

    suggestions.forEach((suggestion, index) => {
      const button = document.createElement("button")
      button.type = "button"
      button.className = "list-group-item list-group-item-action"
      button.textContent = `${suggestion.emoji} ${suggestion.label}`
      button.dataset.action = "click->map#selectSuggestion"
      button.dataset.index = index
      this.suggestionsTarget.appendChild(button)
    })
  }

  selectSuggestion(event) {
    const suggestion = this.currentSuggestions[event.currentTarget.dataset.index]

    this.addressInputTarget.value = suggestion.label
    this.suggestionsTarget.innerHTML = ""
    this.map.flyTo({ center: suggestion.lngLat, zoom: 15 })

    if (suggestion.type === "spot") {
      this.resetCategoryFilter()
      const match = this.markers.find(({ id }) => id === suggestion.spotId)
      if (match) match.marker.togglePopup()
    } else {
      this.showSearchMarker(suggestion.lngLat[0], suggestion.lngLat[1], suggestion.label)
    }
  }

  resetCategoryFilter() {
    this.markers.forEach(({ marker }) => { marker.getElement().style.display = "" })
    this.filterButtonTargets.forEach((button) => {
      button.classList.toggle("chip--active", button.dataset.category === "all")
    })
  }

  hideSuggestionsSoon() {
    setTimeout(() => { this.suggestionsTarget.innerHTML = "" }, 150)
  }

  showSearchMarker(lng, lat, label) {
    if (this.searchMarker) this.searchMarker.remove()

    this.searchMarker = new mapboxgl.Marker({ color: "#dc3545" })
      .setLngLat([lng, lat])

    if (label) this.searchMarker.setPopup(new mapboxgl.Popup().setText(label))

    this.searchMarker.addTo(this.map)
  }

  centerOnUserLocation() {
    if (!("geolocation" in navigator)) return

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { longitude, latitude } = position.coords
        this.map.flyTo({ center: [longitude, latitude], zoom: 14 })
      },
      () => {}
    )
  }
}
