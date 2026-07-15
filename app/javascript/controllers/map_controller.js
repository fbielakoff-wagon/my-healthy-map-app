import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

// Same colors as $food-coral / $movement-blue / $wellbeing-lilac in
// app/assets/stylesheets/config/_colors.scss.
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

export default class extends Controller {
  static values = { token: String, spots: Array }

  connect() {
    mapboxgl.accessToken = this.tokenValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [-0.0778, 51.5074], // London fallback — Mapbox wants [longitude, latitude], not lat/lng
      zoom: 12
    })

    this.addMarkers()
    this.centerOnUserLocation()
  }

  addMarkers() {
    this.markers = this.spotsValue.map((spot) => {
      const el = document.createElement("div")
      el.className = "spot-marker"
      el.style.backgroundColor = CATEGORY_COLORS[spot.category] || "#6c757d" // grey fallback for any other category
      el.textContent = CATEGORY_EMOJI[spot.category] || "📍"

      const marker = new mapboxgl.Marker({ element: el })
        .setLngLat([spot.longitude, spot.latitude])
        .setPopup(new mapboxgl.Popup().setText(spot.name))
        .addTo(this.map)

      return { marker, category: spot.category }
    })
  }

  centerOnUserLocation() {
    if (!("geolocation" in navigator)) return // browser doesn't support it — keep the London fallback

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { longitude, latitude } = position.coords
        this.map.flyTo({ center: [longitude, latitude], zoom: 14 })
      },
      () => {
        // user denied the permission prompt, or it failed — keep the London fallback center
      }
    )
  }
}
