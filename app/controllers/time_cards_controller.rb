class TimeCardsController < ApplicationController
  require 'line/bot'
  require 'net/https'
  require 'uri'
  require 'json'

  before_action :convert_calumn_from_params, only: [:create, :update]
  before_action :get_user_info, :user_present, only: [:create, :update, :destroy]

  def create
    if @id.present?
      redirect_to action: 'update'
    else
      time_card = TimeCard.new(user_id: @user.id, date: @date, work_time: @work_time, start_time: @start_time, finish_time: @finish_time, break_time: @break_time)
      result = time_card.save
      if result == true
        return_message = "修正しました"
      else
        return_message = "修正できませんでした"
      end
      response = send_return_line_message(return_message)
    end
  end

  def edit
      @timecard = TimeCard.new
  end

  def update
    if @user.present?
      time_card = TimeCard.find(@id)
      @result = time_card.update(date: @date, work_time: @work_time, start_time: @start_time, finish_time: @finish_time, break_time: @break_time)
      if @result == true
        return_message = "#{@date.to_date.strftime("%m/%d")}の勤怠を修正しました"
        response = send_return_line_message(return_message) #LINEに修正成功のメッセージを送信する
      else
        return_message = "勤怠を修正できませんでした"
        response = send_return_line_message(return_message)
      end
      render :json => @result
    else
      send_no_user_message
      redirect_to action: 'edit'
    end
  end

  def destroy
    get_user_info
    if @user.present?
      time_card = TimeCard.find(@id)
      if time_card.destroy
        return_message = "#{params[:time_card][:date].to_date.strftime("%m/%d")}の勤怠を修正しました"
        response = send_return_line_message(return_message) #LINEに修正成功のメッセージを送信する
      else
        return_message ="勤怠の修正に失敗しました"
        response = send_return_line_message(return_message)
      end
      respond_to do |format|
        format.html { render "edit"}
        format.json
      end
    else
      send_no_user_message
      redirect_to action: 'edit'
    end
  end

  #勤怠修正フォームの日付が変更された時にuserIdと日付に該当するTimeCardレコードをユーザーに返すアクション
  def set_record_for_form
    input_date = params[:input_date]
    user_id_token = params[:user_id_token]
    user_line_id = get_user_id_from_token(user_id_token)
    user_id = User.find_by(line_id: user_line_id)
    @timecard = TimeCard.find_by(user_id: user_id, date: input_date)
  end

  private

  #トークンを利用してフォームの送信者を取得するメソッド。返り値は、Userのインスタンス
  def get_user_info
    @user = User.find_by(line_id: get_user_line_id)
  end

  #paramsからuserのlineIDを取得するメソッド。返り値にLineIdを返す。
  def get_user_line_id
    user_id_token = params[:time_card][:user_token]
    user_line_id = get_user_id_from_token(user_id_token)
    return user_line_id
  end

  #フォームに付与したトークンを元にlineサーバーからuserのlineIDを取得するメソッド
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

  #paramsの情報を扱いやすい形に整形するメソッド
  def convert_calumn_from_params
    @id = params[:time_card][:timecard_id]
    @date = params[:time_card][:date]
    @start_time = "#{params[:time_card][:date]} #{params[:time_card][:start_time]}".to_time
    @finish_time ="#{params[:time_card][:date]} #{params[:time_card][:finish_time]}".to_time
    @break_time = params[:time_card][:break_time].to_i*60
    @work_time = (@finish_time - @start_time - @break_time).to_i
  end

  #ユーザー登録されているか確認するメソッド
  def user_present
    if @user.nil?
      send_no_user_message
    end
  end

  #リクエストに対する応答するlineメッセージを送信するメソッド
  def send_return_line_message(message)
    client.push_message(get_user_line_id, convert_line_message_style(message))
  end

  #ユーザーが存在しない旨を送信元に送信するメソッド
  def send_no_user_message
    return_message = "ユーザーが見つかりません"
    response = send_return_line_message(return_message)
  end

  #lineのメッセージ形式に整形するメソッド
  def convert_line_message_style(return_message)
    {"type": "text",
      "text": return_message}
  end

end
