# frozen_string_literal: true

ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :email

  # attributes
  has user_id, created_at, updated_at
end
