Rails.application.routes.draw do
  post '/callback' => 'linebot#callback'
  get '/usernew' => 'user#new'
  post '/usercreate' => 'user#create'
  post '/user/user_check_bot' => 'user#user_check_bot'
end
