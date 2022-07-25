class Answer < ApplicationRecord
  validates :body, :reply_to_id, presence: true

  belongs_to :reply_to, class_name: 'Question', foreign_key: :reply_to_id
end
