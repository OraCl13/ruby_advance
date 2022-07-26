class Question < ActiveRecord::Base
  validates :body, :title, presence: true

  has_many :answers, foreign_key: :reply_to_id, dependent: :destroy
  has_many :attachments, dependent: :destroy
end
