import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    requestAnimationFrame(() => this.element.classList.add("is-visible"))
    document.addEventListener("keydown", this.handleKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
  }

  handleKeydown = (event) => {
    if (event.key === "Escape") this.dismiss()
  }

  dismiss() {
    this.element.classList.remove("is-visible")
    this.element.classList.add("is-leaving")
    setTimeout(() => this.element.remove(), 250)
  }
}
