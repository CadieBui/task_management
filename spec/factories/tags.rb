FactoryBot.define do
  factory :tag do
    tagname { Faker::Job.key_skill }
  end
end