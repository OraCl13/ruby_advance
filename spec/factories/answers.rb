# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'MyAnswer' }
    reply_to { Question.create(title: 'new title', body: 'new body') }
    user_id { User.first }
  end
  factory :invalid_answer, class: 'Answer' do
    body { nil }
    reply_to { nil }
  end
end
