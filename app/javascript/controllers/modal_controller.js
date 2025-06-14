import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["usernameInput"]

  closeModal() {
    window.controller = this
    document.body.classList.remove("overflow-y-hidden")
    window.history.back()
    this.element.remove()
  }

  checkUsername() {
    console.log("entra")
    console.log(this.usernameInputTarget.value);

    const username = this.usernameInputTarget.value.trim();
    if (username.length < 3) {
      this.usernameInputTarget.setCustomValidity("Username must be at least 3 characters long.");
    } else {
      this.usernameInputTarget.setCustomValidity("");
    }
    this.usernameInputTarget.reportValidity();
  }
}
