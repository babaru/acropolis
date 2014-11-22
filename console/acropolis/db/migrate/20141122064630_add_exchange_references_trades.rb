class AddExchangeReferencesTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.references :exchange, index: true
    end
  end
end
