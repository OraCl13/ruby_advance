class Answer < ActiveRecord::Base
  validates :body, :reply_to_id, presence: true

  belongs_to :reply_to, class_name: 'Question', foreign_key: :reply_to_id
  has_many :attachments, dependent: :destroy, as: :attachmentable

  # default_scope { order(best_answer: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
