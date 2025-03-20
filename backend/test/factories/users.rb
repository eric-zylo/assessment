FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'Valid1!!' }
    password_confirmation { 'Valid1!!' }
  end
end
