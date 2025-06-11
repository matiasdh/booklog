class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :user, uniqueness: { scope: :post }
end
