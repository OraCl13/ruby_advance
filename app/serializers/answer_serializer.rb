class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :short_body
  has_many :comments
  has_many :attachments

  def short_body
    object.body.truncate(10)
  end
end
