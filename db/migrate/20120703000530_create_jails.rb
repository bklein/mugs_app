class CreateJails < ActiveRecord::Migration
  def change
    create_table :jails do |t|
    	t.string :short_name
    	

      t.timestamps
    end
  end
end
