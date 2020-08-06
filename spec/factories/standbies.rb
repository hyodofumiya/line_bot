FactoryBot.define do
  factory :standby do
    association :user,
      factory: :user
    date : Faker::Date.between(from: 2.days.ago, to: Date.today)
    start : "2020-08-01 07:03:30 -0900"
    break_start : "2020-08-01 10:03:30 -0900"
    break_sum : "600"
  end
end
