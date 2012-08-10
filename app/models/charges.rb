class Charges < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :charge_name, :booking_id
  validates :charge_name, :presence => true
end
