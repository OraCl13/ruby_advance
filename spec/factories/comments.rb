FactoryBot.define do
  factory :comment do
    body { 'COMMENT' }
  end

  factory :invalid_comment, class: Comment do
    body { '' }
  end
end
