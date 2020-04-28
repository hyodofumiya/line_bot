Rails.application.routes.draw do
  post '/callback' => 'linebot#callback'
  get '/usernew' => 'user#new'
  post '/usercreate' => 'user#create'
end
