import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

addEventListener("turbo:before-stream-render", ((event) => {
  const fallbackToDefaultActions = event.detail.render

  event.detail.render = function (streamElement) {
    if (streamElement.action == "redirect") {
      console.log("entra")
      window.location.href = streamElement.getAttribute('location')
    } else {
      fallbackToDefaultActions(streamElement)
    }
  }
}))
