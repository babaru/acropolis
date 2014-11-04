Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :products, :risk_events, :product_risk_parameters
    end
  end


  devise_for :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  resources :products do
    get 'delete'

    resources :product_risk_plans
  end

  resources :clients, :banks, :brokers do
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
end
