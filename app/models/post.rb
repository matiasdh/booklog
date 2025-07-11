class Post < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :comments, dependent: :destroy

  validates :body, presence: true

  scope :with_feed, -> { with_associations
    .recent
    .with_recent_comments
  }

  scope :with_associations, -> {
    includes(:likes, :user, comments: :user)
      .references(:comments)
  }

  scope :recent, -> {
    order(created_at: :desc)
  }

  scope :with_recent_comments, -> {
    order(comments: { created_at: :desc })
  }

  scope :for_user, ->(user) {
    joins(user: :follower_follows)
      .where(user_follows: { user: })
  }

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

  def sorted_comments_by_date
    if comments.loaded?
      comments.sort_by(&:created_at).reverse
    else
      comments.includes(:user).order(comments: { created_at: :desc })
    end
  end
end
