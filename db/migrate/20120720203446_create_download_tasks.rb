class CreateDownloadTasks < ActiveRecord::Migration
  def change
    create_table :download_tasks do |t|
      t.integer :jail_id
      t.string :booking_id
      t.boolean :is_downloaded
      t.boolean :is_processed
      t.string :remote_filename
      t.string :local_filename

      t.timestamps
    end
  end
end
