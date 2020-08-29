FactoryBot.define do
  datetime = DateTime.now
  factory :standby do
    association :user
    date { Date.today}
    start { Time.parse(Date.today.to_s + " 00:00:00")}
    break_start { Time.parse(Date.today.to_s + " 01:00:00")}
    break_sum {30}
  end
end
