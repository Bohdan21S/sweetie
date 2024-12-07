Rails.application.routes.draw do
  get "categories/index"
  get "products/index"
  get "products/show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :products, only: %i[index show]
  resources :categories, only: %i[index]

  devise_for :users
  root "products#index" # Вказуємо головну сторінку

  # devise_for :users do
  #   get "/users/sign_out" => "devise/sessions#destroy"
  # end
  #
  namespace :admin do
    get "orders/index"
    get "orders/update"
    get "orders/destroy"
    get "categories/new"
    get "categories/create"
    get "products/new"
    get "products/create"
    resources :products, only: %i[new create]
    resources :categories, only: %i[new create]
  end

  resources :cart_items, only: %i[create destroy update]
  resource :cart, only: %i[show]


  resources :products, only: %i[show] do
    resources :reviews, only: %i[create edit update]
  end
  
  namespace :admin do
    resources :reviews, only: [:update]
  end


  resources :feedbacks, only: [:new, :create]


  resources :orders, only: [:new, :create, :show]


  get "/nova_poshta/branches", to: "nova_poshta#branches"
  get "/nova_poshta/cities", to: "nova_poshta#cities"


  namespace :admin do
    resources :orders, only: [:index, :update, :destroy, :show]
  end




end
