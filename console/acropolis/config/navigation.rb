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
  navigation.active_leaf_class = 'active_leaf'

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

    primary.item :page_dashboard, fa_icon('dashboard', text: t('navigation.page.dashboard')), dashboard_path, {highlights_on: /dashboard/}

    primary.item :page_risk_plan, "#{fa_icon('life-ring', text: t('navigation.page.risk_plan'))}".html_safe, risk_plans_path, {highlights_on: /risk_plans/}

    primary.item :page_product, "#{fa_icon('archive', text: t('navigation.page.product'))} #{fa_icon('caret-down')}".html_safe, nil, {highlights_on: /products/} do |product_menu|
      product_menu.item :page_product_list, t('models.list', model: Product.model_name.human), products_path
    end

    primary.item :page_client, "#{fa_icon('user', text: t('navigation.page.client'))} #{fa_icon('caret-down')}".html_safe, nil, {highlights_on: /clients/} do |client_menu|
      client_menu.item :page_client_list, t('models.list', model: Client.model_name.human), clients_path
    end

    primary.item :page_broker, "#{fa_icon('user', text: t('navigation.page.broker'))} #{fa_icon('caret-down')}".html_safe, nil, {highlights_on: /brokers/} do |broker_menu|
      broker_menu.item :page_broker_list, t('models.list', model: Broker.model_name.human), brokers_path
    end

    primary.item :page_bank, "#{fa_icon('user', text: t('navigation.page.bank'))} #{fa_icon('caret-down')}".html_safe, nil, {highlights_on: /banks/} do |bank_menu|
      bank_menu.item :page_bank_list, t('models.list', model: Bank.model_name.human), banks_path
    end

  end
end
