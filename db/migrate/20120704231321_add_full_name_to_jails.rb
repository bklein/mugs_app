class AddFullNameToJails < ActiveRecord::Migration
  def change
     change_table :jails do |t|
        t.string :full_name
     end
  end
end
