Rails.application.routes.draw do

  get 'clearing/trading_accounts'

  get 'flatuipro_demo/index'

  namespace :api do
    namespace :v1 do
      post 'trading_accounts/auth', to: 'trading_accounts#auth', as: :trading_account_auth

      get 'trades/latest_of_exchange', to: 'trades#latest_of_exchange'

      resources :products, :risk_events, :product_risk_parameters, :instruments, :exchanges, :trades, :market_prices, :trading_accounts
    end
  end


  devise_for :users, :path_prefix => 'my'
  resources :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'risk_monitor#index'

  resources :products do
    get 'delete'
    post 'monitor'

    resources :product_risk_plans
    resources :trading_accounts
    resources :product_capital_accounts
  end

  resources :operations do
    get 'delete'
  end

  resources :trading_accounts do
    get 'delete'
    get 'clearing'
    post 'calculate_trading_summary'
    post 'export'
    post 'upload_clearing_capital_file'
    get 'uploading_clearing_capital_file'

    post 'upload_clearing_trades_file'
    get 'uploading_clearing_trades_file'

    get 'querying_by_date'
    post 'queried_by_date'

    resources :trading_account_instruments, :trading_account_budget_records

    resources :trading_summaries
  end

  resources :trading_summaries

  get 'clearing_trading_accounts', to: 'clearing#trading_accounts', as: :trading_accounts_clearing

  resources :trading_account_instruments do
    get 'delete'
  end

  resources :trading_account_budget_records do
    get 'delete'
  end

  resources :product_capital_accounts do
    get 'delete'
  end

  resources :banks, :brokers, :exchanges, :instruments, :trading_symbols do
    get 'delete'
  end

  resources :exchanges do
    resources :instruments, :trading_symbols
  end

  resources :trading_symbols do
    resources :instruments
  end

  resources :clients do
    get 'delete'

    resources :capital_accounts
    resources :products
    resources :trading_accounts
  end

  resources :clearing_prices do
    get 'delete'
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

  resources :trading_account_risk_plans do
    get 'delete'
    post 'enable'
  end

  resources :trading_accounts do
    resources :trades
    resources :trading_account_risk_plans
  end

  resources :trades do
    get 'delete'
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

  get 'risk_monitoring', to: 'monitoring#index', as: :risk_monitoring
  get 'risk_monitor', to: 'risk_monitor#index', as: :risk_monitor
end
