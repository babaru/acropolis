class AddProductReferencesToCapitalAccount < ActiveRecord::Migration[5.0]
  def change
    add_reference :capital_accounts, :product, foreign_key: true
  end
end
