class ApplicationController < ActionController::Base
  require 'line/bot'
  require 'json'
  protect_from_forgery :except => [:callback]

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
