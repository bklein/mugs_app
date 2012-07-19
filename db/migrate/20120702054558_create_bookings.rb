class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
			t.string 		:booking_no
			t.datetime 	:booking_datetime
			t.string 		:bond
			t.string		:inmate_name
			t.string 		:inmate_number
			t.integer 	:jail_id
			
      t.timestamps
    end
  end
end
