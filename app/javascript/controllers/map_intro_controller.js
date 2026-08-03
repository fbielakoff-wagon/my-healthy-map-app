import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["intro", "map", "controls"]

  connect() {
    this.revealed = false

    this.handleWheel = this.handleWheel.bind(this)
    this.handleTouchStart = this.handleTouchStart.bind(this)
    this.handleTouchMove = this.handleTouchMove.bind(this)

    this.introTarget.addEventListener("wheel", this.handleWheel, {
      passive: false
    })

    this.introTarget.addEventListener("touchstart", this.handleTouchStart, {
      passive: true
    })

    this.introTarget.addEventListener("touchmove", this.handleTouchMove, {
      passive: false
    })
  }

  disconnect() {
    this.introTarget.removeEventListener("wheel", this.handleWheel)
    this.introTarget.removeEventListener("touchstart", this.handleTouchStart)
    this.introTarget.removeEventListener("touchmove", this.handleTouchMove)
  }

  reveal(event) {
    event?.preventDefault()
    this.showMap()
  }

  handleWheel(event) {
    if (Math.abs(event.deltaY) < 8) return

    event.preventDefault()
    this.showMap()
  }

  handleTouchStart(event) {
    this.touchStartY = event.touches[0].clientY
  }

  handleTouchMove(event) {
    const currentY = event.touches[0].clientY
    const upwardSwipe = this.touchStartY - currentY

    if (upwardSwipe > 20) {
      event.preventDefault()
      this.showMap()
    }
  }

  showMap() {
    if (this.revealed) return

    this.revealed = true

    this.introTarget.classList.add("map-intro--hidden")
    this.mapTarget.classList.add("map-stage__map--revealed")
    this.controlsTarget.classList.add("map-controls--visible")
    this.introTarget.setAttribute("aria-hidden", "true")
  }
}
