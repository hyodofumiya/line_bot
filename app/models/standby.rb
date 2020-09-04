class Standby < ApplicationRecord
  require "date"

  belongs_to :user
  attr_accessor :work_status, :all_of_break_sum

  validates :date, presence: true
  validates :start, presence:true
  validates :break_sum, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than: 86400}
  validate :date_is_today, if: Proc.new { |resource| resource.date.present?}
  validate :start_is_before_now, if: Proc.new { |resource| resource.start.present?}
  validate :break_start_is_today_and_after_start, if: Proc.new {|resource| resource.break_start.present?}
  validate :break_time_sum_is_less_than_from_start, if: Proc.new { |resource| resource.break_sum.present? and resource.start.present?}
  validate :no_record_same_user

  #現在作業中かどうかを判断するvartual attributes
  def work_status
    if self.break_start.present?
      :break
    else
      :work
    end
  end

  #現在までの総合計休憩時間を扱うvartual attributes
  def all_of_break_sum
    if self.break_start.present?
      this_break_time = Time.now - self.break_start
      ((this_break_time + self.break_sum)/60).floor * 60
    else
      self.break_sum
    end
  end

  #出勤情報の日付が当日であることを確認するバリデーション用メソッド
  def date_is_today
    errors.add(:date, "は今日を入力してください") unless self.date == Date.today
  end

  #出勤時刻が現在以前であることを確認するバリデーション用メソッド
  def start_is_before_now
    errors.add(:start, "は現在以前の時刻を入力してください") unless self.start <= Time.now
  end

  #休憩開始時間が異常でないか確認するバリデーション用メソッド
  def break_start_is_today_and_after_start
    if self.break_start.to_date != Date.today
      errors.add(:break_start, "は今日の時刻を入力してください")
    elsif self.start.present?
      if self.break_start < self.start
        errors.add(:break_start, "を開始時刻より後にしてください")
      end
    end
  end

  #休憩時間の合計＜勤務時間合計となっていることを確認するバリデーション用メソッド
  def break_time_sum_is_less_than_from_start
    if self.start <= Time.now
      from_start_to_now = Time.now - self.start.to_time
      this_break_time = self.break_start.present? ? Time.now - self.break_start.to_time : 0
      if self.break_sum + this_break_time > from_start_to_now and self.break_sum < 60*60*24
        errors.add(:base, "休憩時間を勤務時間よりも短くしてください")
      end
    end
  end

  #同一userのレコードが存在していないことを確認するバリデーション用メソッド
  def no_record_same_user
    if self.user_id.present?
      standby_record = Standby.where(user_id: self.user_id)
      another_standby_record = standby_record.select {|s| s.id != self.id }
      if another_standby_record.present?
        errors.add(:base, "すでに別の出勤情報が登録されています")
      end
    end
  end

  #standbyレコードを作成した結果をstringで返すメソッド
  def self.add_new_record
    @standby_record = Standby.find_by(user_id: $user.id)
    if @standby_record.nil?
      record = Standby.new(user_id: $user.id, date: $timestamp, start:$timestamp, break_sum: 0 )
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
    if self.break_start.present? #休憩中か判断し、休憩中の場合は休憩を終了する。
      return "休憩を終了できませんでした。" if self.update_break_sum == false
    end
    time_from_start_to_finish = $timestamp - self.start
    #前日の入力忘れの場合とで条件分け
    if time_from_start_to_finish <= 60*60*24
      if self.break_sum.present?
        work_time = (time_from_start_to_finish - self.break_sum).to_i
      else
        work_time = (time_from_start_to_finish).to_i
      end
      TimeCard.create_new_record_flow(work_time, self, user)
    else
      self.delete
      return "連続勤務が24時間を超えているため登録できません。日付を分けて修正画面から入力してください。"
    end
  end

  #２回目以降の休憩終了処理で休憩時間を更新するメソッド
  def update_break_sum
    update_record = self.update(break_start: nil, break_sum: self.all_of_break_sum)
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
        client.push_message(standby.user.line_id, message)

        #ユーザーのリッチメニューに修正ボタンを表示させる
        richmenu_id = Richmenu.find(4).richmenu_id
        client.link_user_rich_menu(standby.user.line_id, richmenu_id)

        #StandbyレコードをTimeCardレコードとして保存する
        standby.finish_work(standby.user)
      rescue => error
        puts error
      end
    end
  end

end