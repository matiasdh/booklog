import { Controller } from "@hotwired/stimulus"
import { z } from "zod/v4";

export default class extends Controller {
  static formValidationSchema = z.object({
    name: z.string().min(1, "Name is required"),
    email: z.string().email("Invalid email address"),
    password: z.string().min(6, "Password must be at least 6 characters long").optional(),
    password_confirmation: z.string().optional(),
  });

  validate(event) {
    event.preventDefault()

    const formData = new FormData(this.element)
    const data = Object.fromEntries(formData.entries())

    const result = formValidationSchema.safeParse(data)
    console.log(data)
    console.log(result)

    if (!result.success) {
      this.showErrors(result.error.errors)
    } else {
      this.clearErrors()
      this.element.submit()
    }
  }

  showErrors(errors) {
    this.clearErrors()
    errors.forEach(error => {
      const field = this.element.querySelector(`[name="${error.path[0]}"]`)
      const errorEl = document.createElement("p")
      errorEl.className = "text-red-600 text-sm mt-1"
      errorEl.textContent = error.message
      field.insertAdjacentElement("afterend", errorEl)
    })
  }

  clearErrors() {
    this.element.querySelectorAll(".text-red-600").forEach(el => el.remove())
  }
}
