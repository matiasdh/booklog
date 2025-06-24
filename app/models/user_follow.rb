class UserFollow < ApplicationRecord
  belongs_to :user
  belongs_to :follow, class_name: "User"

  validates :user, uniqueness: { scope: :follow }

  validate :user_cannot_follow_themselves

  private

  def user_cannot_follow_themselves
    return unless user == follow

    errors.add(:user, "cannot follow themselves")
  end
end
