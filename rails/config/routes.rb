Rails.application.routes.draw do
  root to: 'landings#index'
  get '/chats', to: 'visitors#index'
  get '/send_mail', to: 'visitors#send_mail'
end