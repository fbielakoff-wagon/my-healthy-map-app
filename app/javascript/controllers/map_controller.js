import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = { token: String }

  connect() {
    mapboxgl.accessToken = this.tokenValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [-0.0778, 51.5074], // London fallback — Mapbox wants [longitude, latitude], not lat/lng
      zoom: 12
    })

    this.centerOnUserLocation()
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
