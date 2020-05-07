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

  private

end