FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    name { username.capitalize }
    surname { username.capitalize }
    password 'password'
    password_confirmation { password }
    role :user

    factory :guest do
      role nil
    end

    factory :admin do
      role :admin
    end
  end
end
