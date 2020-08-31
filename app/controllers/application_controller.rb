class ApplicationController < ActionController::Base
  require 'line/bot'
  require 'json'
  protect_from_forgery :except => [:callback]

  #アプリの管理者lineのアカウントをclientとして定義する。
  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "S5fTELJVb90Nr4PW9YQcQettd2e7ox4eVHOKpdNXqOs8akh5BVjVLLzfr4EPFVaQsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJMgjxLBuMAE8fGgu32MdhFjH2jBhad/Ro7T4Y7e5Yx31AdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
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
end
