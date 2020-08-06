FactoryBot.define do
  factory :time_card do
    association :user,
      factory: :user
    date : Faker::Date.between(from: 2.days.ago, to: Date.today)
    work_time : "12000"
    start_time : "07:03:30"
    finish_time : "10:33:30"
    break_time : "600"
end
