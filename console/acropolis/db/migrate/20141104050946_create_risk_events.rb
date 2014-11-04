class CreateRiskEvents < ActiveRecord::Migration
  def change
    create_table :risk_events do |t|
      t.references :product, index: true
      t.datetime :happened_at
      t.text :remark
      t.references :operation, index: true

      t.timestamps
    end
  end
end
