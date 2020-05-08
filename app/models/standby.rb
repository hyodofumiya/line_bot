class Standby < ApplicationRecord
  belongs_to :user

  require "date"

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
    binding.pry
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
        this_breaktime_sum = $timestamp - @record.break_start
        all_breaktime_sum = @record.break_sum + this_breaktime_sum
        binding.pry
        update_record = @record.update(break_start: nil, break_sum: all_breaktime_sum)
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