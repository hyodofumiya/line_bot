class TimeCardsController < ApplicationController
  require 'line/bot'
  require 'net/https'
  require 'uri'
  require 'json'

  def create
    binding.pry
    user_id_token = params[:time_card][:user_token]
    user_line_id = get_user_id_from_token(user_id_token)
    user_id = User.find_by(line_id: user_line_id)
    timecard_id = params[:time_card][:timecard_id]
    if user_id.nil?
      redirect_to action: 'edit', notice: 'ユーザーが見つかりません。'
    elsif timecard_id.present?
      redirect_to action: 'update'
    end
    time_card = TimeCard.find(params[:time_card][:timecard_id])
    work_time = Time.strptime(params[:time_card][:finish_time], "%H:%M") - Time.strptime(params[:time_card][:start_time], "%H:%M")
    start_time = "#{params[:time_card][:date]} #{params[:time_card][:start_time]}".to_time
    finish_time ="#{params[:time_card][:date]} #{params[:time_card][:finish_time]}".to_time
    result = time_card.create
    if result == true
      return_message = "修正しました"
    else
      return_message = "修正できませんでした"
    end
  end

  def edit
      @timecard = TimeCard.new
  end

  def update
    #ユーザーに入力内容の確認メッセージを送信する
    time_card = TimeCard.find(params[:time_card][:timecard_id])
    work_time = Time.strptime(params[:time_card][:finish_time], "%H:%M") - Time.strptime(params[:time_card][:start_time], "%H:%M")
    start_time = "#{params[:time_card][:date]} #{params[:time_card][:start_time]}".to_time
    finish_time ="#{params[:time_card][:date]} #{params[:time_card][:finish_time]}".to_time
    time_card_update = time_card.update(date: params[:time_card][:date], work_time: work_time, start_time: start_time, finish_time: finish_time, break_time: params[:time_card][:break_time].to_i*60)
    user_id_token = params[:time_card][:user_token]
    user_line_id = get_user_id_from_token(user_id_token)
    if time_card_update == true
      return_message = "#{params[:time_card][:date].to_date.strftime("%m/%d")}の勤怠を修正しました"
      response = client.push_message(user_line_id, return_change_timecard_message(return_message))
      render "edit"
    else
      return_message = '更新できませんでした'
      response = client.push_message(user_line_id, return_change_timecard_message(return_message))
    end
  end

  #勤怠修正フォームの日付が変更された時にuserIdと日付に該当するTimeCardレコードをユーザーに返すアクション
  def set_record_for_form
    input_date = params[:input_date]
    user_id_token = params[:user_id_token]
    user_line_id = get_user_id_from_token(user_id_token)
    user_id = User.find_by(line_id: user_line_id)
    #@timecard = TimeCard.find_by(user_id: user_id, date: input_date)
    @timecard = TimeCard.find_by(user_id: 1, date: input_date)
  end

  private
  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def get_user_id_from_token(user_id_token)
    uri = URI.parse('https://api.line.me/oauth2/v2.1/verify')
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)

    req.set_form_data({"id_token":user_id_token, "client_id":"1654154094"})
    res = http.request(req)
    
    result = ActiveSupport::JSON.decode(res.body)
    user_id = result["sub"]
    
    return user_id
  end

  def return_change_timecard_message(return_message)
    {"type": "text",
      "text": return_message}
  end

end
