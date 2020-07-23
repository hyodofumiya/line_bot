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
        binding.pry
      else
        redirect_to new_user_session_path
      end
    else
      redirect_to new_user_session_path
    end
    binding.pry
  end
end