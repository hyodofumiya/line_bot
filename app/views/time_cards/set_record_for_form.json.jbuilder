json.exist @timecard.present?
if @timecard.present?
  json.start_time @timecard.start_time.strftime("%H:%M")
  json.finish_time @timecard.finish_time.strftime("%H:%M")
  json.break_time @timecard.break_time
end