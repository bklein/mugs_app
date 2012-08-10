class AddIsDownloadedToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :is_downloaded, :boolean, :default => false
  end
end
