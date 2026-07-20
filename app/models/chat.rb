class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :health_goal
  belongs_to :spot, optional: true

  has_many :messages, dependent: :destroy
end
