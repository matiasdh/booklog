class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :username, length: { minimum: 3 }

  has_many :posts, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :comments, dependent: :destroy

  has_many :user_follows, dependent: :destroy
  has_many :followed_users, through: :user_follows, source: :follow

  def follows?(user)
    user_follows.exists?(follow: user)
  end

  def follow(user)
    user_follows.find_or_create_by(follow: user).valid?
  end

  def unfollow(user)
    user_follows.find_by(follow: user)&.destroy.present?
  end
end
