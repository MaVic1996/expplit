Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  #Authentication  
  post '/auth/login', to: 'authentication#login'
  post '/auth/register', to: 'authentication#register'
end
