class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
			
			t.integer 	:booking_id
			t.string 		:charge_name
			
      t.timestamps
    end
  end
end
