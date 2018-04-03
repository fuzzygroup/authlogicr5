Rails.application.routes.draw do
  get '/health', to: "health#index"
  get '/home', to: "home#index"
  get '/tour', to: "tour_spending#index"
  get '/status', to: "credential_checks#index"
  post '/api/add_user_and_password', to: 'api#add_user_and_password'
  get '/api/cron_update_check', "api#cron_update_check"
  post "/api/update_user_and_subscription", to: "api#update_user_and_subscription"
  
  get '/search', to: "search#index"
  get "/dates_and_times", to: "dates_and_times#index"
  

  resources :users, only: [:new, :create]
  
  get '/jobs/filter', "jobs#filter"
  resources :jobs
  resources :notes
  resources :cover_letters
  resources :tasks
  resources :reports
  resources :news_feed
  resources :deadlines
  resources :possible_times
  
  resources :tours
  # resources :setup_wizard
  # resources :tour_spending
  # resources :tour_other
  resources :job_search_urls
  
  # resources :credentials do
  #   member do
  #     get :test_password
  #   end
  # end
  #get "/credentials/test_password", to: "credentials#test_password"
  
  # resources :credential_checks
  # resources :purchases
  # resources :budgets
  # resources :alert_addresses

  resources :user_sessions, only: [:create, :destroy]

  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in
  get '/health', to: "health#index"
  get '/health/df', to: "health#df"
  get '/health/hosts', to: "health#hosts"
  get "/health/who", to: "health#who"
  get "/signups/new", to: "users#new"
  

  get '/logout', to: 'user_sessions#destroy', as: :logout
  get '/login', to: 'user_sessions#new', as: :login
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  get "/signup", to: "signups#new", as: :signup
  
  
  # resources :api do
  #   get :usernames, to: 'api#usernames'
  # end
  
  # get "/api/usernames", to: "api#usernames"
  # get "/api/usernames_with_subscription_types", to: "api#usernames_with_subscription_types"
  # get "/api/subscription_type", to: "api#subscription_type"
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  # resources :me
  
  resources :pricing

  #mount RailsDb::Engine => '/rails/db', :as => 'rails_db'

  
  # resources :sources
  resources :signups
  root to: 'visitors#index'
  
end
