class ApplicationController < ActionController::Base
  require 'line/bot'
  require 'json'
  protect_from_forgery :except => [:callback]

  #アプリの管理者lineのアカウントをclientとして定義する。
  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_channel[:secret]
      Rails.application.credentials.line_channel[:token]
    }
  end

  #リクエストの送信元がLINEアプリからか判別するメソッド
  def check_from_line
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      response_bad_request
    end
  end

  #ログイン後の画面を設定
  def after_sign_in_path_for(resource)
    admin_time_cards_path
  end

  #ユーザーの権限に応じてログアウト後のページのパスを返すメソッド
  def after_sign_out_path_for(resource, admin)
    if admin
      new_user_session_path 
    else
      user_session_login_path
    end
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


  #レスポンｽにエラーを返す
  def response_bad_request
    render status: 400, json: { status: 400, message: '無効な通信です' }
  end
  
end
