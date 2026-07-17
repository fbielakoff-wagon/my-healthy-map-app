class HealthGoal < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy

  validates :name, presence: true
end
