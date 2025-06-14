import { Application } from "@hotwired/stimulus"
import {InputValidator} from "stimulus-inline-input-validations"


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register("input-validator", InputValidator)

export { application }
