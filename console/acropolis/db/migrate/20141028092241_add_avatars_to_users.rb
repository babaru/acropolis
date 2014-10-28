class AddAvatarsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :avatar
      t.string :attachment_access_token
    end
  end

  def self.down
    drop_attached_file :users, :avatar
    remove_column :users, :attachment_access_token
  end
end
