class Post < ApplicationRecord
  belongs_to :user, optional: false
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :body, presence: true

  def liked_by?(user)
    if likes.loaded?
      likes.any? { |v| v.user_id == user.id }
    else
      likes.exists?(user: user)
    end
  end

  def mark_as_liked_by(user:)
    return false if liked_by?(user)

    likes.create!(user: user)
    true
  end

  def remove_like_from(user:)
    false unless liked_by?(user)

    likes.find_by(user: user).destroy!
    true
  end
end
