class CreateTradingSummaryParameters < ActiveRecord::Migration
  def change
    create_table :trading_summary_parameters do |t|
      t.references :trading_summary, index: true
      t.string :parameter_name
      t.decimal :parameter_value, precision: 20, scale: 4, default: 0

      t.timestamps
    end
  end
end
