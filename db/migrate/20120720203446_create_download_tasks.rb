class CreateDownloadTasks < ActiveRecord::Migration
  def change
    create_table :download_tasks do |t|
      t.integer :jail_id
      t.string :booking_id
      t.string :remote_filename

      t.timestamps
    end
  end
end
