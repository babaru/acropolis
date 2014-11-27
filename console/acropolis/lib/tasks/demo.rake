namespace :demo do
  task :reset => :environment do

    %w(brokers capital_accounts clients market_prices monitoring_products
      position_close_records product_capital_accounts product_risk_parameters
      product_risk_plans products trades trading_account_budget_records
      trading_account_instruments trading_account_trading_summaries
      trading_accounts trading_summaries).each do |table_name|
      ActiveRecord::Base.connection.execute("truncate #{table_name}")
    end

  end

  task :risk_plans => :environment do

    %w(risk_plans risk_plan_operations thresholds parameters relation_symbols
      operations translations).each do |table_name|
      ActiveRecord::Base.connection.execute("truncate #{table_name}")
    end

    # Basic Risk Parameters
    # -----------------------------

    Parameter.create(name: 'net_worth')
    Parameter.create(name: 'margin')
    Parameter.create(name: 'exposure')

    # Parameters Chinese Name
    # -----------------------------

    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.parameter.net_worth', value: '净值')
    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.parameter.margin', value: '保证金')
    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.parameter.exposure', value: '敞口')


    # Basic Relation Symbols of Thresholds
    # -----------------------------

    RelationSymbol.create(math: '<', name: 'less_than')
    RelationSymbol.create(math: '<=', name: 'less_than_and_equals_to')
    RelationSymbol.create(math: '=', name: 'equals_to')
    RelationSymbol.create(math: '>=', name: 'greater_than_and_equals_to')
    RelationSymbol.create(math: '>', name: 'greater_than')

    # Relation Symbols Chinese Name
    # -----------------------------

    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.less_than', value: '小于')
    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.less_than_and_equals_to', value: '小于等于')
    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.equals_to', value: '等于')
    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.greater_than_and_equals_to', value: '大于等于')
    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.greater_than', value: '大于')

    # Basic Operation of Risk Plan
    # -----------------------------

    Operation.create(name: 'warning', level: 1)
    Operation.create(name: 'cease_open', level: 5)
    Operation.create(name: 'force_close', level: 10)

    # Operation Chinese Name
    # -----------------------------

    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.operation.warning', value: '预警')
    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.operation.cease_open', value: '停止开仓')
    Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.operation.force_close', value: '强制平仓')

  end

end