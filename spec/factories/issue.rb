FactoryGirl.define do
  factory :issue do
    sequence(:title) { |n| "Important issue #{n}" }
    description { "Description of #{title}" }
    priority { Issue.priorities.keys.sample }
    association :creator, factory: :user

    factory :issue_with_comments do
      transient do
        comment_count 5
      end

      after(:create) do |issue, evaluator|
        create_list(:comment, evaluator.comment_count, issue: issue)
      end
    end
  end
end
