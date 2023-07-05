Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  # devise_for :users
  # ActiveAdmin
  ActiveAdmin.routes(self) if Object.const_defined?('ActiveAdmin')

  get '/Site/SaraJLeadholm', to: 'paintings#home'
  get '/profile', to: 'paintings#profile'

  get '/contact', to:'paintings#contact'
  get '/ideal', to: 'paintings#ideal'
  get '/journal', to: 'paintings#journal'
  get '/home', to:'paintings#home'

  get '/portraits', to: 'paintings#portraits'
  get '/galleries', to: 'paintings#galleries'
  get '/winterscapes', to: 'paintings#winterscapes'
  get '/northshore', to:'paintings#northshore'
  get '/landscapes', to:'paintings#landscapes'
  get '/oceanside', to:'paintings#oceanside'
  get '/prints', to: 'paintings#prints'

  resources :paintings, only: [:show, :index] do


    # resource :portrait, only: [:show, :update]

    # resolve('Portrait') { route_for(:portrait)}
    # resolve('Galleries') { route_for(:galleries)}
    # resolve('Northshore') { route_for(:northshore)}
    # resolve('Landscapes') { route_for(:landscapes)}
    # resolve('Oceanside') { route_for(:oceanside)}
    # resolve('Prints') { route_for(:prints)}
    # resolve('Winterscapes') { route_for(:winterscapes)}
  end
  # Defines the root path route ("/")
  root "paintings#home"

end
