class Standby < ApplicationRecord
  require "date"

  belongs_to :user

  validates :user, presence: true
  validates :date, presence: true
  validates :start, presence:true
  validates :break_sum, length: { maximum: 60*60*24}

  #standbyレコードを作成するメソッド
  def self.add_new_record
    #standbyレコードを新たに作成してもいいか確認するメソッド
    @standby_record = Standby.find_by(user_id: $user.id) if present?
    if @standby_record.nil? #新規作成
      user_id = $user.id
      record = Standby.new(user_id: user_id, date: $timestamp, start:$timestamp )
      create_record = record.save
      if create_record = true
        return "出勤しました"
      else
        return "出勤に失敗しました。やり直してください。"
      end
    else
      if @standby_record.break_start.nil?
        return "すでに出勤しています"
      else
        return "休憩中です"
      end
    end
  end

  def self.add_startbreak_to_record
    @record = Standby.find_by(user_id: $user.id)
    if @record.present?
      if @record.break_start.nil?
        update_record = @record.update(break_start: $timestamp)
        if update_record == true
          return "休憩を開始しました"
        else
          return "休憩の開始に失敗しました"
        end
      else
        return "#{@record.break_start.strftime("%H時%M分")}から休憩中です"
      end
    else
      return Standby.no_stanby_record
    end
  end

  def self.add_breaksum_to_record
    @record = Standby.find_by(user_id: $user.id)
    if @record.present?
      if @record.break_start.present?
        update_record = @record.update_break_sum
        if update_record == true
          return "休憩を終了しました"
        else
          return "休憩の終了に失敗しました"
        end
      else
        return "休憩を開始していません"
      end
    else
      return Standby.no_stanby_record
    end
  end

  def self.finish_work_flow
    standby = Standby.find_by(user_id: $user.id)
    #出勤しているか確認する
    if standby.present?
      #休憩中か判断し、休憩中の場合は休憩を終了する。
      work_status = standby.break_start
      if work_status.present?
        update_break_sum = standby.update_break_sum
        return "退勤に失敗しました。休憩を終了できませんでした。" if update_break_sum.break_start.present?
      end
      work_start = standby.start
      break_sum = standby.break_sum
      full_work_hour = $timestamp - work_start
      #前日の入力忘れの場合とで条件分け
      if full_work_hour <= 60*60*24
        work_time = full_work_hour
        work_time -= break_sum if break_sum.present?
        TimeCard.create_new_record_flow(work_time, standby)
      else
        standby.delete
        return "連続勤務が24時間を超えているため登録できません。１日の勤務時間が24時間以内になるように編集画面から分けて入力してください。"
      end
    else
      return "先に出勤してください"
    end
  end

  def update_break_sum
    this_breaktime_sum = $timestamp - self.break_start
    all_breaktime_sum = this_breaktime_sum
    all_breaktime_sum += self.break_sum if self.break_sum.present?
    update_record = self.update(break_start: nil, break_sum: all_breaktime_sum)
    return update_record
  end

  def self.no_stanby_record
    "出勤していません"
  end
end