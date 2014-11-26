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
end