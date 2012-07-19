require 'spec_helper'

describe Charges do
  describe "basic validations" do
 	
 	before(:each) do 
 		@jail = Jails.new
 		@jail.short_name = "alachua"
 		@booking = Bookings.new
 		@booking.jail_id = @jail.id
 	end
 	
  
  
  	it "should have a charge name" do 
  		charge = FactoryGirl.build(:charge)
  		charge.should be_valid
  	end
  	
  	it "can't have an empty charge name" do
  		charge = FactoryGirl.build(:charge, :charge_name => '')
  		charge.should_not be_valid
  	end
  	
  
  end
end
