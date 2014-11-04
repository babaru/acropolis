class CreateProductRiskParameters < ActiveRecord::Migration
  def change
    create_table :product_risk_parameters do |t|
      t.references :product, index: true
      t.references :parameter, index: true
      t.decimal :value, precision: 20, scale: 4
      t.datetime :happened_at

      t.timestamps
    end
  end
end
