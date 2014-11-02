class AddParameterReferencesToThresholds < ActiveRecord::Migration
  def change
    change_table :thresholds do |t|
      t.references :parameter, index: true
    end
  end
end
