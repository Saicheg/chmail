Rails.application.routes.draw do
  root to: 'landings#index'
  mount Sidekiq::Web => '/sidekiq'

  # get '/chats', to: 'visitors#index'
  # get '/send_mail', to: 'visitors#send_mail'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

end
