FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    endtime { Faker::Time.forward(days: 5, period: :morning)}
    status { Faker::Number.between(from: 0, to: 3)}
    priority { Faker::Number.between(from: 0, to: 2)}
    userid {'41ee4cfd-5fd8-4f9a-96d4-a2d3516acf36'}
  end
end


