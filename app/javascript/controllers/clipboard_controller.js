import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    text: String
  }

  async copy(event) {
    event.preventDefault()

    try {
      await navigator.clipboard.writeText(this.textValue)
      this.showNotification("Link copied!")
    } catch (error) {
      console.error("Could not copy share link:", error)
      window.prompt("Copy this link:", this.textValue)
    }
  }

  showNotification(message) {
    const notification = document.createElement("div")

    notification.className = "alert alert-success alert-dismissible fade show"
    notification.setAttribute("role", "alert")
    notification.innerHTML = `
      ${message}
      <button
        type="button"
        class="btn-close"
        data-bs-dismiss="alert"
        aria-label="Close">
      </button>
    `

    document.body.appendChild(notification)

    setTimeout(() => {
      notification.remove()
    }, 2500)
  }
}
