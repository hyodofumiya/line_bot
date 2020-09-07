json.exist @timecard.present?
json.user_exist "true"
if @timecard.present?
  json.start_time @timecard.start_time.strftime("%H:%M")
  json.finish_time @timecard.finish_time.strftime("%H:%M")
  json.break_time @timecard.break_time
  json.timecard_id @timecard.id
end