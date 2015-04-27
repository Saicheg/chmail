Rails.application.routes.draw do
  root to: 'landings#index'
  get '/chats', to: 'visitors#index'
end