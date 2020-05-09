class TimeCard < ApplicationRecord
  belongs_to :user

  def self.create_new_record_flow(work_time, standby)
    time_card = TimeCard.find_by(user_id: $user.id, date: standby.date)
    #ユーザーのレコードが同日に被っていないか確認する
    if time_card.nil?
      time_card = TimeCard.new(user_id: $user.id, date: standby.date, work_time: work_time, start_time: standby.start, finish_time: $timestamp, break_time: standby.break_sum)
      result = time_card.save
    else
      work_time = work_time + time_card.work_time
      break_time =  standby.break_sum + time_card.break_time
      result = time_card.update(work_time: work_time, finish_time: $timestamp, break_time: break_time)
    end

    #DBに保存できたか確認
    if result == true
      standby.delete
      return "退勤しました"
    else
      return "退勤に失敗しました"
    end
  end
end
