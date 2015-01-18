class CreateUploadFiles < ActiveRecord::Migration
  def change
    create_table :upload_files do |t|
      t.attachment :data_file
      t.string :attachment_access_token
      t.string :meta_data

      t.timestamps
    end
  end
end
