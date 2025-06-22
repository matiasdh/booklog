import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect () {
    document.body.classList.add("overflow-y-hidden")
  }

  disconnect () {
    document.body.classList.remove("overflow-y-hidden")
  }

  closeModal() {
    window.history.back()
    this.element.remove()
  }
}
