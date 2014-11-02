class RemoveTypeColumnFromThresholds < ActiveRecord::Migration
  def up
    change_table :thresholds do |t|
      t.remove :type
    end
  end

  def down
    change_table :thresholds do |t|
      t.string :type, default: 'ParameterThreshold'
    end
  end
end
