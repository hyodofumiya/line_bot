class Standby < ApplicationRecord
  belongs_to :user

  require "date"

  #standbyレコードを作成するメソッド
  def self.add_new_record(date)
    binding.pry
    #standbyレコードを新たに作成してもいいか確認するメソッド
    if Standby.find_by(line_id: $user_id).nil?
      #新規作成
      record = Standby.new(line_id:$user_id, date: date.to_date, start:date.to_time )
      create_record = record.save
      binding.pry
    else
    #エラー対応のメソッド
      #レスポンスに返すメッセージを選択するメソッド
      return_message = select_return_message()
      #リッチメニューの内容が正しいか判断するメソッド
    end
    #リッチメニューを適切なものに切り替えるメソッド
  end

  def self.return_message
  end
  private

  def select_return_message

  end
end