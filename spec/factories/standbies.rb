FactoryBot.define do
  datetime = DateTime.now
  factory :standby do
    association :user
    date {datetime.to_date}
    start {datetime.since(-1.hour)}
    break_start {datetime.since(-30.minutes)}
    break_sum {60}
  end
end
