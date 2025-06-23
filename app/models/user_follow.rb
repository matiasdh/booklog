class UserFollow < ApplicationRecord
  belongs_to :user, counter_cache: :following_count
  belongs_to :follow, class_name: "User", counter_cache: :followers_count

  validates :user, uniqueness: { scope: :follow_id }

  validate :user_cannot_follow_themselves

  private

  def user_cannot_follow_themselves
    return unless user == follow

    errors.add(:user, "cannot follow themselves")
  end
end
