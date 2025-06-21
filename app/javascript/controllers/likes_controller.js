import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

export default class extends Controller {
  static targets = ["likesButton", "textLabel", "likesCount"]
  static values = {
    liked: Boolean
  }

  connect() {
    this.isLoading = false
  }

  async toggleLike(event) {
    event?.preventDefault()
    if (this.isLoading) return

    const wasLiked = this.likedValue
    const newLiked = !wasLiked
    const currentCount = parseInt(this.likesCountTarget.textContent || "0", 10)

    this.isLoading = true
    this.setButtonDisabled(true)

    // Optimistic update
    newLiked ? this.markLiked(currentCount + 1) : this.markUnliked(currentCount - 1)

    const result = await this.callApi(newLiked)

    if (result.success) {
      const serverCount = result.data?.post?.likes
      if (typeof serverCount === "number") {
        newLiked ? this.markLiked(serverCount) : this.markUnliked(serverCount)
      }
    } else {
      // Revert if request failed
      wasLiked ? this.markLiked(currentCount) : this.markUnliked(currentCount)
    }

    this.setButtonDisabled(false)
    this.isLoading = false
  }

  async callApi(liking) {
    const method = liking ? "post" : "delete"
    const request = new FetchRequest(method, this.element.action, {
      contentType: "application/json",
      responseKind: "json"
    })

    try {
      const response = await request.perform()
      if (!response.ok) return { success: false }

      const data = await response.json
      return { success: true, data }
    } catch (error) {
      console.error("Like API request failed:", error)
      return { success: false }
    }
  }

  markLiked(count) {
    this.likedValue = true
    this.likesButtonTarget.classList.add("text-pink-600")
    this.textLabelTarget.textContent = count !== 1 ? "Likes" : "Like"
    this.likesCountTarget.textContent = count
  }

  markUnliked(count) {
    this.likedValue = false
    this.likesButtonTarget.classList.remove("text-pink-600")
    this.textLabelTarget.textContent = count !== 1 ? "Likes" : "Like"
    this.likesCountTarget.textContent = count
  }

  setButtonDisabled(state) {
    this.likesButtonTarget.disabled = state
  }
}
