class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  #lineログイン時にlineからのコールバックを受け取るメソッド
  def line
    basic_action
  end

  private

  #LINEログイン時のリダイレクト先を定義
  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      user = User.find_by(line_id: @omniauth['uid'])
      if user
        bypass_sign_in(user) #ここでdeviseにログイン処理を強制している
        redirect_to admin_time_cards_path
      else
        redirect_to user_session_login_path, alert: "社員情報が見つかりません。"
      end
    else
      redirect_to user_session_login_path, alert: "lineログインできませんでした。"
    end
    
  end
end