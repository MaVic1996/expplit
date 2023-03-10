Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  #Authentication  
  post '/auth/login', to: 'authentication#login'
  post '/auth/register', to: 'authentication#register'
  post '/auth/vinculate_account', to: 'authentication#vinculate_account'

  resources :groups do
    collection do 
      get 'member_groups', to: 'groups#member_groups'
      get 'managed_groups', to: 'groups#managed_groups'
    end
    member do 
      put 'join', to: 'groups#join_group'
    end
  end

  resources :users, except: [:show, :update, :destroy] do
    collection do 
      get 'my_data', to: 'users#my_data'
      get 'from_group/:group', to: 'users#list_from_group'
    end
    member do
      get '', to: 'users#user_data'
      put 'add_in_group', to: 'users#add_user_in_group'
      delete 'delete_from_group', to: 'users#delete_from_group' 
    end
  end
end
