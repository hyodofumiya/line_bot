class TimeCard < ApplicationRecord
  belongs_to :user

  validates :date, presence: true 
  validates :work_time, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validate :starttime_and_finishtime_valid

  #勤務開始時刻が勤務終了時刻よりも前であることを確認するメソッド。カスタムバリデーションとして作成。
  def starttime_and_finishtime_valid
    errors.add(:finish_time, "終了時刻を開始時刻よりも前に設定してください") unless 
      self.start_time < self.finish_time
    binding.pry
  end

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
      message = "勤務履歴\n\n日付：#{start_time.strftime("%Y")}年 #{start_time.strftime("%m")}月#{start_time.strftime("%d")}日\n勤務開始：#{start_time.strftime("%H:%M")}\n勤務終了：#{finish_time.strftime("%H:%M")}\n\n合計\n作業：#{timecard.work_time/(60*60)}時間#{timecard.work_time%(60*60)/60}分\n休憩：#{timecard.break_time/(60*60)}時間#{timecard.break_time%(60*60)/60}分"

    elsif selected_date >= Time.now
      message = "勤務履歴\n\n未登録"
    else
      message = "勤務履歴\n\n日付：#{selected_date.strftime("%Y")}年 #{selected_date.strftime("%m")}月#{selected_date.strftime("%d")}日 \n\n休日"
    end
    return message
  end

  def self.index_selected_date
    this_month = Time.now.to_date.all_month
    last_month = Time.now.last_month.to_date.all_month
    this_month_timecards = TimeCard.where(user_id: $user.id, date: this_month).order(date: :asc)
    last_month_timecards = TimeCard.where(user_id: $user.id, date: last_month).order(date: :asc)
    this_month_timecards_message = TimeCard.create_timecards_index_message(this_month_timecards, this_month, Time.now.to_date)
    last_month_timecards_message = TimeCard.create_timecards_index_message(last_month_timecards, last_month, Time.now.last_month.to_date)
    this_and_last_month_timecards_message = TimeCard.compile_this_and_last_month_timecards_message(this_month_timecards_message, last_month_timecards_message)
    return this_and_last_month_timecards_message
  end

  private

  def self.create_timecards_index_message(timecards,all_month, year_and_month)
    #休日も含めた勤怠の記録がまとまった配列を作成
    message_parts = []
    for date in all_month do
      timecard = timecards.find_by(date: date)
      if timecard.present?
       message_part = TimeCard.record_into_message(date,timecard)
      else
        message_part = TimeCard.not_record_into_message(date)
      end
      message_parts << message_part
    end
    return self.compile_a_month_timecards_message(message_parts, year_and_month)
    puts @num
  end

  def self.record_into_message(date,timecard)
    message =  {
      "type": "box",
      "layout": "horizontal",
      "contents": [
        {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "#{date.day}日",
              "size": "md",
              "align": "end"
            }
          ],
          "width": "15%"
        },
        {
          "type": "box",
          "layout": "horizontal",
          "contents": [
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{timecard.work_time/(60*60)}時間",
                  "align": "end"
                }
              ]
            },
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{timecard.work_time%(60*60)/60}分",
                  "align": "end"
                }
              ],
              "margin": "none",
              "width": "35%"
            }
          ],
          "width": "40%"
        },
        {
          "type": "box",
          "layout": "horizontal",
          "contents": [
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{timecard.break_time/(60*60)}時間",
                  "align": "end"
                }
              ]
            },
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{timecard.break_time%(60*60)/60}分",
                  "align": "end"
                }
              ],
              "width": "35%"
            }
          ],
          "width": "40%"
        }
      ]
    }
    return message
  end

  def self.not_record_into_message(date)
    {
      "type": "box",
      "layout": "horizontal",
      "contents": [
        {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "#{date.day}日",
              "size": "md",
              "align": "end"
            }
          ],
          "width": "15%"
        },
        {
          "type": "box",
          "layout": "horizontal",
          "contents": [
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "休日",
                  "align": "center"
                }
              ]
            }
          ],
          "width": "40%"
        }
      ]
    }
  end

  def self.compile_a_month_timecards_message(message_parts, year_and_month)
    compiled_a_month_message = {
      "type": "bubble",
      "header": {
        "type": "box",
        "layout": "vertical",
        "contents": [
          {
            "type": "text",
            "text": "#{year_and_month.year}年#{year_and_month.month}月の勤務履歴",
            "size": "md",
            "align": "center"
          }
        ],
        "paddingBottom": "0px"
      },
      "body": {
        "type": "box",
        "layout": "vertical",
        "contents": [
          {
            "type": "box",
            "layout": "horizontal",
            "contents": [
              {
                "type": "box",
                "layout": "vertical",
                "contents": [
                  {
                    "type": "text",
                    "text": "日付",
                    "size": "md",
                    "align": "end",
                    "decoration": "underline"
                  }
                ],
                "width": "15%"
              },
              {
                "type": "box",
                "layout": "horizontal",
                "contents": [
                  {
                    "type": "box",
                    "layout": "vertical",
                    "contents": [
                      {
                        "type": "text",
                        "text": " 作業時間",
                        "align": "center",
                        "decoration": "underline"
                      }
                    ]
                  }
                ],
                "width": "40%"
              },
              {
                "type": "box",
                "layout": "horizontal",
                "contents": [
                  {
                    "type": "box",
                    "layout": "vertical",
                    "contents": [
                      {
                        "type": "text",
                        "text": "休憩時間",
                        "align": "center",
                        "decoration": "underline"
                      }
                    ]
                  }
                ],
                "width": "40%"
              }
            ]
          },
          {
            "type": "box",
            "layout": "vertical",
            "contents": message_parts
          }
        ],
        "margin": "sm"
      },
      "styles": {
        "header": {
          "separator": true
        }
      }
    }
  end

  def self.compile_this_and_last_month_timecards_message(this_month_timecards_message, last_month_timecards_message)
    compiled_this_and_last_month_message = 
    {
      "type": "flex",
      "altText": "Flex Message",
      "contents": {
          "type": "carousel",
          "contents": [
            this_month_timecards_message,
            last_month_timecards_message
          ]
        }
    }
  end

end
