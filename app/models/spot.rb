class Spot < ApplicationRecord
  belongs_to :user

  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :chats, dependent: :nullify

  CATEGORIES = %w[food wellness fitness].freeze

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :city, presence: true
end
