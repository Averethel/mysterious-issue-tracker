FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment #{n} body" }
    issue
  end
end
