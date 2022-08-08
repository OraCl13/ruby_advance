class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :article, polymorphic: true
end
