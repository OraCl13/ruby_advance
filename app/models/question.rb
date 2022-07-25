class Question < ApplicationRecord
  validates :body, :title, presence: true

  has_many :answers, foreign_key: :reply_to_id, dependent: :destroy
end
