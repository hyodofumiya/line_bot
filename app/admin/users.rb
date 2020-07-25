ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :family_name, :first_name, :employee_number, :line_id, :admin_user, :encrypted_password
  #
  # or
  #
  # permit_params do
  #   permitted = [:family_name, :first_name, :employee_number, :line_id, :admin_user, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  menu label: "社員一覧"

end
