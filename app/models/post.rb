class Post < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :comments, dependent: :destroy

  validates :body, presence: true

  def liked_by?(user)
    if likes.loaded?
      likes.any? { |v| v.user_id == user.id }
    else
      likes.exists?(user: user)
    end
  end

  def mark_as_liked_by(user:)
    likes.find_or_create_by(user: user).present?
  end

  def remove_like_from(user:)
    likes.find_by(user: user)&.destroy.present?
  end
end
