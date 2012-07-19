class AddMugshotToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :mugshot, :string
  end
end
