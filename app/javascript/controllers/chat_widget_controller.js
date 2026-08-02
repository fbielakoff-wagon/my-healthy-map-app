import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "toggle", "dot"]

  connect() {
    // Show the dot again if there's a coach reply the user hasn't seen yet.
    // (Simplest signal: compare last-open timestamp to now; swap for a real
    // "unread" flag from the server later if you want it precise.)
    const lastOpened = localStorage.getItem("coachWidgetLastOpened")
    if (!lastOpened) this.dotTarget?.classList.remove("chat-widget__dot--hidden")
  }

  toggle() {
    this.panelTarget.classList.toggle("chat-widget--open")
    this.toggleTarget.classList.toggle("chat-widget__toggle--open")

    if (this.panelTarget.classList.contains("chat-widget--open")) {
      this.dotTarget?.classList.add("chat-widget__dot--hidden")
      localStorage.setItem("coachWidgetLastOpened", Date.now())
    }
  }
}
