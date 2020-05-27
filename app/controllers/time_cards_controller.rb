class TimeCardsController < ApplicationController
  require 'line/bot'
  require 'net/https'
  require 'uri'
  require 'json'

  def create
  end

  def edit
      @timecard = TimeCard.new
  end

  def update
    user_id_token = params[:user_token]
    #LINEのIDトークンをLINEに送信し、LINEのIDを取得する
    @user_id = get_user_id_from_token(user_id_token)
    #ユーザーに入力内容の確認メッセージを送信する
    return_check_message()
    render nothing: true
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
