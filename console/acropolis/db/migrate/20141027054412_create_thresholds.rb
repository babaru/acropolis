class CreateThresholds < ActiveRecord::Migration
  def change
    create_table :thresholds do |t|
      t.references :risk_plan, index: true
      t.references :relation_symbol, index: true
      t.decimal :value, precision: 20, scale: 4

      t.timestamps
    end
  end
end
