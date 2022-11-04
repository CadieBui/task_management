FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.name }
    password { "1111" }
  end
end
