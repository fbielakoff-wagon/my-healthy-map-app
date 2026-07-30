import { Controller } from "@hotwired/stimulus"

// Best-effort: fills hidden lat/lng fields on the message form so the AI
// coach can ground its replies in spots near the user. If location isn't
// available (denied, unsupported, or just hasn't resolved yet), the fields
// stay blank and the message still sends fine — just without that context.
export default class extends Controller {
  static targets = ["lat", "lng"]

  connect() {
    if (!navigator.geolocation) return

    navigator.geolocation.getCurrentPosition(
      ({ coords }) => {
        this.latTarget.value = coords.latitude
        this.lngTarget.value = coords.longitude
      },
      () => {}
    )
  }
}
