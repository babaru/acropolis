class CreateTradingSummaries < ActiveRecord::Migration
  def change
    create_table :trading_summaries do |t|
      t.string :type
      t.decimal :net_worth
      t.decimal :customer_benefit
      t.decimal :leverage
      t.decimal :margin
      t.decimal :exposure
      t.decimal :profit
      t.decimal :balance

      t.timestamps
    end
  end
end
