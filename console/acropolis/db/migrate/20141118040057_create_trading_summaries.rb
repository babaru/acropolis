class CreateTradingSummaries < ActiveRecord::Migration
  def change
    create_table :trading_summaries do |t|
      t.string :type
      t.decimal :net_worth, precision: 20, scale: 4
      t.decimal :customer_benefit, precision: 20, scale: 4
      t.decimal :leverage, precision: 20, scale: 4
      t.decimal :margin, precision: 20, scale: 4
      t.decimal :exposure, precision: 20, scale: 4
      t.decimal :profit, precision: 20, scale: 4
      t.decimal :balance, precision: 20, scale: 4

      t.timestamps
    end
  end
end
