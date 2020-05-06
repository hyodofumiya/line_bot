Rails.application.routes.draw do
  post '/callback' => 'linebots#callback'
  get '/usernew' => 'user#new'
  post '/usercreate' => 'user#create'
  post '/user/user_check_bot' => 'user#user_check_bot'
  get 'richmenu/start_work_menu' => 'richmenus#start_work_menu'
  
  resources :standby
end
