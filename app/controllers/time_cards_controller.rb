class TimeCardsController < ApplicationController
  require 'line/bot'
  require 'net/https'
  require 'uri'
  require 'json'

  def create
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
      notice "修正しました"
    else
      notice "修正できませんでした"
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
    time_card.update(date: params[:time_card][:date], work_time: work_time, start_time: start_time, finish_time: finish_time, break_time: params[:time_card][:break_time].to_i*60)
    if time_card == true
      render nothing: true
    else
      notice "修正できませんでした"
    end
  end

  def set_record_for_form
    input_date = params[:input_date]
    user_id_token = params[:user_id_token]
    user_line_id = get_user_id_from_token(user_id_token)
    user_id = User.find_by(line_id: user_line_id)
    #@timecard = TimeCard.find_by(user_id: user_id, date: input_date)
    @timecard = TimeCard.find_by(user_id:1, date: input_date)
    #LINEIDトークンからuserIDを取得するメソッドを呼び出す
      #user登録されているか判断する
        #されていなかった場合は、ユーザー登録を実施する旨を返す

    #フォームから送信された日付を元にtimecardテーブルからレコードを検索する

      #該当するレコードの有無で条件分けを行う
        #レコードが存在した場合
        #フォームに返すdataをjson形式にする
        #Jsonを返す
      #該当するレコードが存在しない場合
        #何も実行しない

  end

  private

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

end
