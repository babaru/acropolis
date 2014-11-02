class AddTypeFieldToThresholds < ActiveRecord::Migration
  def change
    change_table :thresholds do |t|
      t.string :type, default: 'ParameterThreshold'
    end
  end
end
