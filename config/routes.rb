Rails.application.routes.draw do
  post '/callback' => 'linebot#callback'
  get '/google967db6eac48064ec.html' => 'google_domain_set#show'

end
