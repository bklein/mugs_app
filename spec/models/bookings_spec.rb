require 'spec_helper'

describe Bookings do
  describe "basic validations" do
  	it "should have a name" do
  		booking = FactoryGirl.build(:booking, :inmate_name => "Jone")
  		booking.should be_valid
  	end
  	
  	it "should not have a blank name" do	
  		booking = FactoryGirl.build(:booking, :inmate_name => "")
  		booking.should_not be_valid
  	end
  	
  	it "should have a booking number" do
  		booking = FactoryGirl.build(:booking, :booking_no => "A123")
  		booking.should be_valid
  	end
  	
  	it "should not have an empty booking number" do 
  		booking = FactoryGirl.build(:booking, :booking_no => '')
  		booking.should_not be_valid
  	end
  	
  	it "should have a bond amount >= 0" do
			booking = FactoryGirl.build(:booking, :bond => 5000)
			booking.should be_valid
			
			booking = FactoryGirl.build(:booking, :bond => 0)
			booking.should be_valid
		end
		
		it "should not have a negative bond" do
			booking = FactoryGirl.build(:booking, :bond => -20)
			booking.should_not be_valid
		end
		
		
			
  end
end
