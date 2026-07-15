class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :spots, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_spots,
            through: :favourites,
            source: :spot
  has_many :shares, dependent: :destroy

  has_one :preference, dependent: :destroy

  has_many :active_follows,
           class_name: "Follow",
           foreign_key: :follower_id,
           dependent: :destroy

  has_many :following,
           through: :active_follows,
           source: :following

  has_many :passive_follows,
           class_name: "Follow",
           foreign_key: :following_id,
           dependent: :destroy

  has_many :followers,
           through: :passive_follows,
           source: :follower
end
