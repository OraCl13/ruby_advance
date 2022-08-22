# frozen_string_literal: true

ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body
  indexes reply_to.title, as: :question_title
  indexes reply_to.body, as: :question_body, sortable: true
  indexes reply_to_id

  # attributes
  has user_id, created_at, updated_at
end
