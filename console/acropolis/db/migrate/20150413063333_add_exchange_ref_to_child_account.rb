class AddExchangeRefToChildAccount < ActiveRecord::Migration
  def change
    add_reference :child_accounts, :exchange, index: true
    add_foreign_key :child_accounts, :exchanges
  end
end
