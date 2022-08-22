class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :article, polymorphic: true

  after_create :send_message_new_comment

  private

  def send_message_new_comment
    MessageForAnswerJob.perform_now(id, "com_#{article_type}")
  end
end
