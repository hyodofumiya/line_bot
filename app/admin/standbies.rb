ActiveAdmin.register Standby do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :date, :start, :break_start, :break_sum
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :date, :start, :break_start, :break_sum]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  menu label: "出勤状況"

  index do
    selectable_column
    id_column
    column :user_id
    column :date
    column :start
    column :break_start
    column :break_sum
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :date
      f.input :start
      f.input :break_start
      f.input :break_sum
    end
    f.actions
  end

end
