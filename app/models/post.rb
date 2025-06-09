class Post < ApplicationRecord
  belongs_to :user, optional: false

  validates :body, presence: true
end
