# frozen_string_literal: true

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file, :created_at, :updated_at
end
