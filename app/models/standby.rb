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
      if create_record == true
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

  #休憩開始処理をするメソッド
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

  #休憩終了処理をするメソッド
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

  #Standbyをユーザーのリクエストを受けて退勤処理する際にこのメソッドで退勤処理をしていいのか判断するメソッド
  def self.finish_work_flow
    standby = Standby.find_by(user_id: $user.id)
    #出勤しているか確認する
    if standby.present?
      #退勤処理を実行
      standby.finish_work($user)
    else
      return "先に出勤してください"
    end
  end

  #StandbyレコードからTimeCardレコードを作成するメソッド
  def finish_work(user)
    #休憩中か判断し、休憩中の場合は休憩を終了する。
    work_status = self.break_start
    if work_status.present?
      update_break_sum = self.update_break_sum
      return "退勤に失敗しました。休憩を終了できませんでした。" if update_break_sum == false
    end
    work_start = self.start
    break_sum = self.break_sum
    full_work_hour = $timestamp - work_start
    #前日の入力忘れの場合とで条件分け
    if full_work_hour <= 60*60*24
      work_time = full_work_hour
      work_time -= break_sum if break_sum.present?
      TimeCard.create_new_record_flow(work_time, self, user)
    else
      self.delete
      return "連続勤務が24時間を超えているため登録できません。１日の勤務時間が24時間以内になるように編集画面から分けて入力してください。"
    end
  end

  #２回目以降の休憩終了処理で休憩時間を更新するメソッド
  def update_break_sum
    this_breaktime_sum = $timestamp - self.break_start
    all_breaktime_sum = this_breaktime_sum
    all_breaktime_sum += self.break_sum if self.break_sum.present?
    update_record = self.update(break_start: nil, break_sum: all_breaktime_sum)
    return update_record
  end

  #出勤していない場合のメッセージ
  def self.no_stanby_record
    "出勤していません"
  end

  #日付が変わったタイミングで定時実行されるメソッド。Standbyテーブルの全てのレコードをTimeCardに保存した上でユーザーにTimeCardの修正を促すメッセージを送信する
  def self.task_to_reset_standby_table
    standbies = Standby.all.includes(:user)
    #処理の順番で退勤時間にムラがないように退勤時間を定義しておく
    now = Time.now
    $timestamp = Time.new(now.year, now.month, now.day, hour = 23, min = 59, sec = nil, utc_offset = nil)
    
    standbies.each do |standby|
      #途中でエラーが生じても残りのレコードの処理が中断されないように例外処理の記述をしている
      begin
        #ユーザーにTimeCardの修正を促すメッセージを送信する
        message = {
          type: 'text',
          text: "#{now.month}月#{now.day}日の勤怠簿が退勤していません。修正ボタンから正しい内容に修正してください。"
        }
        Standby.client.push_message(standby.user.line_id, message)

        #ユーザーのリッチメニューに修正ボタンを表示させる
        richmenu_id = Richmenu.find(4).richmenu_id
        Standby.client.link_user_rich_menu(standby.user.line_id, richmenu_id)

        #StandbyレコードをTimeCardレコードとして保存する
        standby.finish_work(standby.user)
      rescue => error
        puts error
      end
    end
  end

  #LINEのメッセージAPIを使用するためのメソッド
  def self.client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "S5fTELJVb90Nr4PW9YQcQettd2e7ox4eVHOKpdNXqOs8akh5BVjVLLzfr4EPFVaQsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJMgjxLBuMAE8fGgu32MdhFjH2jBhad/Ro7T4Y7e5Yx31AdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
  end

end