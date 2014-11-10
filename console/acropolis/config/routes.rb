Rails.application.routes.draw do

  get 'inspinia/index'

  get 'flatuipro_demo/index'

  namespace :api do
    namespace :v1 do
      resources :products, :risk_events, :product_risk_parameters
    end
  end


  devise_for :users, :path_prefix => 'my'
  resources :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  resources :products do
    get 'delete'
    post 'monitor'

    resources :product_risk_plans
    resources :trading_accounts
    resources :product_capital_accounts
  end

  resources :trading_accounts do
    get 'delete'
  end

  resources :product_capital_accounts do
    get 'delete'
  end

  resources :banks, :brokers do
    get 'delete'
  end

  resources :clients do
    get 'delete'

    resources :capital_accounts
  end

  resources :capital_accounts do
    get 'delete'
  end

  resources :product_risk_plans do
    get 'delete'
    post 'enable'
  end

  resources :risk_plans do
    get 'delete'

    resources :risk_plan_operations
  end

  resources :risk_plan_operations do
    get 'delete'
    post 'enable'
  end

  resources :monitoring_products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  get 'dashboard', to: 'dashboard#index', as: :dashboard
  get 'dashboard/switch_monitor_layout', to: 'dashboard#switch_monitor_layout', as: :dashboard_switch_monitor_layout

  get 'monitoring', to: 'monitoring#index', as: :monitoring
end
