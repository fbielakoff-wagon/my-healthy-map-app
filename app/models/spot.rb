class Spot < ApplicationRecord
  belongs_to :user

  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :shares, dependent: :destroy
end
