class Order < ActiveRecord::Base
  attr_accessible :booking_id, :email, :stripe_card_token, :inmate_name
  
  
end
