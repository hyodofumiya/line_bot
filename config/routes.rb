Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }

  post '/callback' => 'linebots#callback'
  get '/usernew' => 'user#new'
  post '/usercreate' => 'user#create'
  post '/user/user_check_bot' => 'user#user_check_bot'
  get 'richmenu/start_work_menu' => 'richmenus#start_work_menu'
  get 'timecard/edit' => 'time_cards#edit'
  post 'time_cards/:id(.:format)' => 'time_cards#update'
  post 'timecard/set_record' => 'time_cards#set_record_for_form'
  resources :time_cards

end
