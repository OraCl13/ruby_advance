class Question < ActiveRecord::Base
  validates :body, :title, presence: true

  has_many :answers, foreign_key: :reply_to_id, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachmentable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
