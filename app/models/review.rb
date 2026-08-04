class Review < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :body, length: { maximum: 500 }, allow_blank: true
  validates :user_id, uniqueness: { scope: :spot_id, message: "have already reviewed this spot" }
end
