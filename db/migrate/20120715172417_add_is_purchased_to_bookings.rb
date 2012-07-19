class AddIsPurchasedToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :is_purchased, :boolean, :default => false
  end
end
