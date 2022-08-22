# frozen_string_literal: true

ThinkingSphinx::Index.define :comment, with: :active_record do
  # fields
  indexes body, sortable: true
  indexes article_type, as: :comment_type

  # attributes
  has user_id, created_at, updated_at
end
