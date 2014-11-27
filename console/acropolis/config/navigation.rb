# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items.
  # Defaults to 'selected' navigation.selected_class = 'your_selected_class'
  navigation.selected_class = 'active'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'active_leaf'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that
  # will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name, item| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # If this option is set to true, all item names will be considered as safe (passed through html_safe). Defaults to false.
  # navigation.consider_item_names_as_safe = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>if: -> { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>unless: -> { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.
    #

    primary.item(
        :page_risk_monitoring,
        fa_icon('desktop', text: t('navigation.page.risk_monitoring')),
        risk_monitor_path,
        {
          highlights_on: /risk_monitoring/
        }
      )

    #
    # Risk control menus
    #
    primary.item :page_risk_plan, fa_icon('life-ring', text: RiskPlan.model_name.human), nil, {} do |risk_plan_menu|

      if recent_items(:risk_plan).length > 0
        recent_items(:risk_plan).map do |id, name|
          risk_plan_menu.item(
            "page_risk_plan_#{id}".to_sym,
            fa_icon('clock-o', text: name),
            risk_plan_path(id: id),
            {
              highlights_on: Regexp.new("risk_plans/#{id}")
            }
          )
        end
      end

      risk_plan_menu.item(
        :page_risk_plan,
        t('models.all', model: RiskPlan.model_name.human),
        risk_plans_path,
        {
          highlights_on: /risk_plans(\/)*$/
        }
      )

    end

    #
    # Client menus
    #
    primary.item :page_client, fa_icon('empire', text: Client.model_name.human), nil, {} do |client_menu|
      if recent_items(:client).length > 0
        recent_items(:client).map do |id, name|
          client_menu.item(
            "page_client_#{id}".to_sym,
            fa_icon('clock-o', text: name),
            client_path(id: id),
            {
              highlights_on: Regexp.new("clients/#{id}")
            }
          )
        end
      end

      client_menu.item(
        :page_client_list,
        t('models.all', model: Client.model_name.human),
        clients_path,
        {
          highlights_on: /clients(\/)*$/
        }
      )
    end

    #
    # Products menus
    #
    primary.item :page_product, fa_icon('archive', text: Product.model_name.human), nil, {} do |product_menu|
      if recent_items(:product).length > 0
        recent_items(:product).map do |id, name|
          product_menu.item(
            "page_product_#{id}".to_sym,
            fa_icon('clock-o', text: name),
            product_path(id: id),
            {
              highlights_on: Regexp.new("products/#{id}")
            }
          )
        end
      end

      product_menu.item(
        :page_product_list,
        t('models.all', model: Product.model_name.human),
        products_path,
        {
          highlights_on: /products(\/)*$/
        }
      )
    end

    #
    # TradingAccounts menus
    #
    primary.item :page_trading_account, fa_icon('user', text: TradingAccount.model_name.human), nil, {} do |trading_account_menu|
      if recent_items(:trading_account).length > 0
        recent_items(:trading_account).map do |id, name|
          trading_account_menu.item(
            "page_trading_account_#{id}".to_sym,
            fa_icon('clock-o', text: name),
            trading_account_path(id: id),
            {
              highlights_on: Regexp.new("trading_accounts/#{id}")
            }
          )
        end
      end

      trading_account_menu.item(
        :page_trading_account_list,
        t('models.all', model: TradingAccount.model_name.human),
        trading_accounts_path,
        {
          highlights_on: /trading_accounts(\/)*$/
        }
      )
    end

    #
    # Trading menus
    #
    primary.item :page_exchange, fa_icon('exchange', text: Exchange.model_name.human), nil, {} do |exchange_menu|

      if recent_items(:exchange).length > 0
        recent_items(:exchange).map do |id, name|
          exchange_menu.item(
            "page_exchange_#{id}".to_sym,
            fa_icon('clock-o', text: name),
            exchange_path(id: id),
            {
              highlights_on: Regexp.new("exchanges/#{id}")
            }
          )
        end
      end

      exchange_menu.item(
        :page_exchange,
        t('models.all', model: Exchange.model_name.human),
        exchanges_path,
        {
          highlights_on: /exchanges/
        }
      )

    end

    primary.item :page_data, fa_icon('database', text: t('navigation.page.data')), nil, {} do |data_menu|
    end

    primary.item :page_settings, fa_icon('cog', text: t('navigation.page.settings')), nil, {} do |settings_menu|
      settings_menu.item :page_broker_list, Broker.model_name.human, brokers_path
      settings_menu.item :page_bank_list, Bank.model_name.human, banks_path
      settings_menu.item :page_operation_list, Operation.model_name.human, operations_path
    end

  end
end
