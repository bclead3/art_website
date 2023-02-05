Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

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
