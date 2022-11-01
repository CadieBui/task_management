FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    endtime { Faker::Time.forward(days: 5, period: :morning)}
    status { Faker::Number.between(from: 0, to: 3)}
    priority { Faker::Number.between(from: 0, to: 2)}
    user
  end
end


