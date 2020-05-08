class Standby < ApplicationRecord
  belongs_to :user

  require "date"

  #standbyレコードを作成するメソッド
  def self.add_new_record(date, user)
    #standbyレコードを新たに作成してもいいか確認するメソッド
    @standby_record = Standby.find_by(user_id: user.id) if present?
    if @standby_record.nil? #新規作成
      user_id = user.id
      record = Standby.new(user_id: user_id, date: date.to_date, start:date.to_time )
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
    #リッチメニューを適切なものに切り替えるメソッド
  end

  def self.add_startbreak_to_record(date)
    binding.pry
    @record = Standby.find_by(user_id: $user.id)
    if @record.present?
      if @record.break_start.nil?
        update_record = @record.update(break_start: date.to_time)
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
    binding.pry
  end

  def self.add_breaksum_to_record(date)
    @record = Standby.find_by(user_id: $user.id)
    if @record.present?
      if @record.break_start.present?
        this_break_time_sum = date.to_time - @record.break_start
        binding.pry
        update_record = @record.update(break_start: "", break_sum: this_break_time_sum)
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
    binding.pry
  end

  def self.no_stanby_record
    "出勤していません"
  end
end