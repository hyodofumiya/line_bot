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
        redirect_to admin_root_path
      else
        redirect_to new_user_session_path
      end
    else
      redirect_to new_user_session_path
    end
    
  end
end