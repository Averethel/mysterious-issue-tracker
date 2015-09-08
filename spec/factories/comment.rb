FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment #{n} body" }
    association :creator, factory: :user
    issue
  end
end
