FactoryBot.define do
  datetime = DateTime.now
  factory :time_card do
    association :user
    date {datetime.to_date}
    work_time {60*59}
    start_time {datetime.since(-1.hour)}
    finish_time {datetime}
    break_time {60}
  end
end
