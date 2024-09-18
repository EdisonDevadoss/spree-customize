Rails.application.routes.draw do
  namespace :seller do
    resources :orders, only: [:index, :show] do
      member do
        patch 'update_line_item/:line_item_id', to: 'orders#update_line_item', as: :update_line_item
        patch 'approve_line_item/:line_item_id', to: 'orders#approve_line_item', as: :approve_line_item
        patch 'cancel_line_item/:line_item_id', to: 'orders#cancel_line_item', as: :cancel_line_item
      end
    end
    resources :registrations, only: [:new, :create]
    get 'onboarding/navigate', to: 'onboarding#navigate', as: 'navigate_onboarding'
    resources :onboarding, only: [:new]
    resources :shops, only: [:create, :edit, :update]
    resources :shop_infos, only: [:create, :edit, :update]
    resources :shop_billing_infos, only: [:create, :edit, :update]
    resources :dashboard, only: [:index]
    resources :listing, only: [:index, :new, :create, :destroy, :edit, :update]
    get 'listing/clone/:product_id', to: 'listing#clone', as: 'clone'
    resources :setting, only: [:index]
    get 'profile/:shop_id', to: 'profile#index', as: 'profile'
    resources :profile, only: [:edit, :update]
    resources :billing_info, only: [:index]
    resources :shipping_configuration, only: [:new, :create, :edit, :update]
    resources :stock_locations, only: [:new, :create]
  end

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  Spree::Core::Engine.routes.draw do
    namespace :seller do
      resources :orders, only: [:index, :show] do
        member do
          patch 'update_line_item/:line_item_id', to: 'orders#update_line_item', as: :update_line_item
          patch 'approve_line_item/:id', to: 'orders#approve_line_item', as: :approve_line_item
          patch 'cancel_line_item/:id', to: 'orders#cancel_line_item', as: :cancel_line_item
        end
      end
      resources :registrations, only: [:new, :create]
      get 'onboarding/navigate', to: 'onboarding#navigate', as: 'navigate_onboarding'
      resources :onboarding, only: [:new]
      resources :shops, only: [:create, :edit, :update]
      resources :shop_infos, only: [:create, :edit, :update]
      resources :shop_billing_infos, only: [:create, :edit, :update]
      resources :dashboard, only: [:index]
      resources :listing, only: [:index, :new, :create, :destroy, :edit, :update]
      get 'listing/clone/:product_id', to: 'listing#clone', as: 'clone'
      resources :setting, only: [:index]
      get 'profile/:shop_id', to: 'profile#index', as: 'profile'
      resources :profile, only: [:edit, :update]
      resources :billing_info, only: [:index]
      resources :shipping_configuration, only: [:new, :create, :edit, :update]
    end
  end

  mount Spree::Core::Engine, at: '/'

  # https://github.com/basecamp/mission_control-jobs?tab=readme-ov-file#basic-configuration
  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

Spree::Core::Engine.add_routes do
  get '/recently_viewed_products' => 'products#recently_viewed'
end
