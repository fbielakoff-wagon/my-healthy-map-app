class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :health_goal

  has_many :messages, dependent: :destroy
end
