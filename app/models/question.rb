class Question < ApplicationRecord
  validates :body, :title, presence: true

  has_many :answers, foreign_key: :reply_to_id, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachmentable
  has_many :comments, dependent: :destroy, as: :article

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :calculate_reputation

  private

  def calculate_reputation
    reputation = Reputation.calculate(self)
    User.find(self.user_id).update(reputation: reputation) if self.user_id
  end
end
