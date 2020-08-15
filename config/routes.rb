Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :groups
      resources :richmenus
      resources :standbies
      resources :time_cards
      resources :user_groups
      resources :line_send, only: [:index, :create]
      root to: "time_cards#index"
    end
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
  get '/user_session/login' => 'user_session#new'
  get 'admin/line_send/search' => 'admin/line_send#search'
  resources :time_cards


end
