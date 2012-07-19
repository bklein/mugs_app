class Charges < ActiveRecord::Base
  # attr_accessible :title, :body
  
  validates :charge_name, :presence => true
end
