import { Controller } from "@hotwired/stimulus"

// A <textarea> doesn't submit its form on Enter by default (Enter just
// inserts a newline there) — this makes plain Enter send the message, while
// Shift+Enter still inserts a newline for a multi-line message.
export default class extends Controller {
  submit(event) {
    if (event.shiftKey) return

    event.preventDefault()
    this.element.closest("form").requestSubmit()
  }
}
