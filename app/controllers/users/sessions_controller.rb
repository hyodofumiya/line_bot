class Users::SessionsController < Devise::SessionsController

  def destroy
    @admin = current_user.admin_user?
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    respond_to_on_destroy
  end

  private
  
  #ユーザーが管理者が一般ユーザーなのかでログアウト後のリダイレクト先を変更
  def respond_to_on_destroy
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name, @admin) }
    end
  end

end
