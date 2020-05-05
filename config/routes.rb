Rails.application.routes.draw do
  post '/callback' => 'linebot#callback'
  get '/usernew' => 'user#new'
  post '/usercreate' => 'user#create'
  post '/user/user_check_bot' => 'user#user_check_bot'
  get 'richmenu/start_work_menu' => 'richmenu#start_work_menu'
  get 'test' => 'richmenu#test'
end
