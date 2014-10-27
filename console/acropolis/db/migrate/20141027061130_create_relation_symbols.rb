class CreateRelationSymbols < ActiveRecord::Migration
  def change
    create_table :relation_symbols do |t|
      t.string :name
      t.string :math

      t.timestamps
    end
  end
end
