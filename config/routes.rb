Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  # devise_for :users
  # ActiveAdmin
  ActiveAdmin.routes(self) if Object.const_defined?('ActiveAdmin')

  get '/profile', to: 'paintings#profile'
  get '/portraits', to: 'paintings#portraits'
  get '/galleries', to: 'paintings#galleries'
  get '/winterscapes', to: 'paintings#winterscapes'
  get '/northshore', to:'paintings#northshore'
  get '/landscapes', to:'paintings#landscapes'
  get '/oceanside', to:'paintings#oceanside'
  get '/contact', to:'paintings#contact'
  get '/ideal', to: 'paintings#ideal'
  get '/journal', to: 'paintings#journal'
  get '/prints', to: 'paintings#prints'
  get '/home', to:'paintings#home'
  # Defines the root path route ("/")
  root "paintings#index"

end
