class CreateProductCapitalAccounts < ActiveRecord::Migration
  def change
    create_table :product_capital_accounts do |t|
      t.references :product, index: true
      t.references :capital_account, index: true

      t.timestamps
    end
  end
end
