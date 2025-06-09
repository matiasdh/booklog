import { Controller } from "@hotwired/stimulus"
import { format } from "timeago.js"

export default class extends Controller {
  static values = { datetime: String }

  connect() {
    this.load()
    this.startRefreshing()
  }

  disconnect() {
    this.stopRefreshing()
  }

  load() {
    this.element.textContent = format(this.datetimeValue)
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.load()
    }, 60_000)
  }

  stopRefreshing() {
    clearInterval(this.refreshTimer)
      this.refreshTimer = null
  }
}
