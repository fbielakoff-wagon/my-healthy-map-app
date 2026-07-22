import { Controller } from "@hotwired/stimulus"

// Jumps the message history to the bottom (most recent message) whenever
// this element appears — on first load and again after Turbo swaps in a
// fresh reply, so you always land on "now" and scroll up for older history.
export default class extends Controller {
  connect() {
    this.element.scrollTop = this.element.scrollHeight
  }
}
