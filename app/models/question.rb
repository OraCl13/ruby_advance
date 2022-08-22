class Question < ApplicationRecord
  validates :body, :title, presence: true

  has_many :answers, foreign_key: :reply_to_id, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachmentable
  has_many :comments, dependent: :destroy, as: :article

  belongs_to :user

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :update_reputation

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
