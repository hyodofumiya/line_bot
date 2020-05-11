class TimeCard < ApplicationRecord
  belongs_to :user



  def self.create_new_record_flow(work_time, standby)
    time_card = TimeCard.find_by(user_id: $user.id, date: standby.date)
    #ユーザーのレコードが同日に被っていないか確認する
    if time_card.nil?
      standby.break_sum = 0 if nil?
      time_card = TimeCard.new(user_id: $user.id, date: standby.date, work_time: work_time, start_time: standby.start, finish_time: $timestamp, break_time: standby.break_sum)
      result = time_card.save
    else
      work_time = work_time + time_card.work_time
      break_time =  time_card.break_time
      break_time += standby.break_sum if standby.break_sum.present?
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

  def self.show_selected_date(selected_date)
    timecard = TimeCard.find_by(user_id: $user.id, date: selected_date)
    selected_date = Date.parse(selected_date)
    if timecard.present?
      start_time = timecard.start_time.in_time_zone('Tokyo')
      finish_time = timecard.finish_time.in_time_zone('Tokyo')  
      message = "勤務履歴\n\n日付：#{start_time.strftime("%Y")}年 #{start_time.strftime("%m")}月#{start_time.strftime("%d")}日\n勤務開始：#{start_time.strftime("%H:%M")}\n勤務終了：#{finish_time.strftime("%H:%M")}\n\n合計\n作業：#{timecard.work_time/(60*60)}時間#{timecard.work_time/60}分\n休憩：#{timecard.break_time/(60*60)}時間#{timecard.break_time/60}分"
    elsif selected_date >= Time.now
      message = "勤務履歴\n\n未登録"
    else
      message = "勤務履歴\n\n日付：#{selected_date.strftime("%Y")}年 #{selected_date.strftime("%m")}月#{selected_date.strftime("%d")}日 \n\n休日"
    end
    return message
  end

end
