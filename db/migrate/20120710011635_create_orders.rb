class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :booking_id
      t.string :inmate_name
      t.string :email
      t.boolean :is_complete, :default => false
      t.string :stripe_card_token
      t.string :remote_ip

      t.timestamps
    end
  end
end
