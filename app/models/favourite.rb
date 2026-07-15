class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :spot_id, uniqueness: { scope: :user_id }
end
