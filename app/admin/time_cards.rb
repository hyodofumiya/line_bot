ActiveAdmin.register TimeCard do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :date, :work_time, :start_time, :finish_time, :break_time
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :date, :work_time, :start_time, :finish_time, :break_time]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  menu label: "勤怠簿一覧"


  index do
    selectable_column
    id_column
    column :user_id
    column :date
    column :work_time
    column :start_time
    column :finish_time
    column :break_time
    actions
  end

end
