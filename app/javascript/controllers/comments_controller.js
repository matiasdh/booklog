import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "toggleButton"]

  toggleForm() {
    this.formTarget.classList.toggle("hidden")
    this.toggleButtonTarget.classList.toggle("text-blue-700")
  }
}
