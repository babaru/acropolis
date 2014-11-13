class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :name
      t.string :type
      t.string :full_cn_name
      t.string :short_cn_name
      t.string :full_en_name
      t.string :short_en_name

      t.timestamps
    end
  end
end
