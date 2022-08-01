class Answer < ApplicationRecord
  validates :body, :reply_to_id, presence: true

  belongs_to :reply_to, class_name: 'Question', foreign_key: :reply_to_id
  has_many :attachments, dependent: :destroy, as: :attachmentable

  default_scope { order(pos_answers_users: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
