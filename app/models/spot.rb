class Spot < ApplicationRecord
  CATEGORIES = %w[food fitness wellness].freeze

  # Lets us call Spot.near([lat, lng], radius_km) — pure SQL distance
  # filtering/ordering on the existing latitude/longitude columns, no
  # migration or external geocoding call involved.
  reverse_geocoded_by :latitude, :longitude

  belongs_to :user, optional: true

  has_many :reviews,    dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :shares,     dependent: :destroy
  has_many :chats,      dependent: :nullify

  validates :name,     presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :city,     presence: true, unless: -> { source == "mapbox" }
  validates :latitude, :longitude, presence: true
  validates :external_id, uniqueness: true, allow_nil: true

  scope :curated,  -> { where(source: "seed") }
  scope :from_api, -> { where(source: "mapbox") }
  scope :by_category, ->(c) { where(category: c) if c.in?(CATEGORIES) }
end
