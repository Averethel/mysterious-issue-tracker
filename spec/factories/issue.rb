FactoryGirl.define do
  factory :issue do
    sequence(:title) { |n| "Important issue #{n}" }
    description { "Description of #{title}"}
    priority { Issue.priorities.keys.sample }
  end
end
