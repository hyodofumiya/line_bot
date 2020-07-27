class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      user = User.find_by(line_id: @omniauth['uid'])
      if user
        bypass_sign_in(user)
      else
        redirect_to new_user_session_path
      end
    else
      redirect_to new_user_session_path
    end
    redirect_to admin_root_path
  end
end