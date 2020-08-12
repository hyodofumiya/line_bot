class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env['omniauth.auth']
    binding.pry
    if @omniauth.present?
      user = User.find_by(line_id: @omniauth['uid'])
      if user
        bypass_sign_in(user)
        redirect_to admin_time_cards_path
      else
        @errors = ["社員情報が見つかりません。", "先に社員登録をしてください。"]
        render "user_session/new"
      end
    else
      @errors = ["lineログインできませんでした。"]
      render "user_session/new"
    end
    
  end
end