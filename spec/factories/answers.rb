FactoryBot.define do
  factory :answer do
    body { "MyText" }
    reply_to { Question.create(title: 'new title', body: 'new body') }
  end
  factory :invalid_answer, class: 'Answer' do
    body { nil }
    reply_to { nil }
  end
end
