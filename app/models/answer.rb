class Answer < ApplicationRecord
  validates :body, :reply_to_id, presence: true

  belongs_to :reply_to, class_name: 'Question', foreign_key: :reply_to_id, touch: true
  belongs_to :user

  has_many :attachments, dependent: :destroy, as: :attachmentable
  has_many :comments, dependent: :destroy, as: :article

  default_scope { order(pos_answers_users: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :send_message_new_answer
  after_update :send_message_new_answer

  private


  def send_message_new_answer
    MessageForAnswerJob.perform_now(id, nil)
  end
end
