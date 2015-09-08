FactoryGirl.define do
  factory :user do
    username { |n| "user_#{n}" }
    name { username.capitalize }
    surname { username.capitalize }
    password "password"
    password_confirmation "password"
  end
end
