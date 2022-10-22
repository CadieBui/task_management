FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    endtime { Faker::Time.forward(days: 5, period: :morning)}
    task_status { Faker::Number.between(from: 0, to: 2)}
  end
end


