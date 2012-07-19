require 'spec_helper'

describe Jails do

	describe "basic validations" do 
	
		it "should have a short(url) name" do
			jail = FactoryGirl.build(:jail, :short_name => "alachua_county")
			jail.should be_valid
		end
		
		it "should not be nameless (url)" do
			jail = FactoryGirl.build(:jail, :short_name => '')
			jail.should_not be_valid
		end
		
		it "should have a unique name (url)" do
			jail = FactoryGirl.create(:jail, :short_name => 'test')
			FactoryGirl.build(:jail, :short_name => 'test').should_not be_valid
		end
		
    it "should have a long name" do
      jail = FactoryGirl.build(:jail, :full_name => "Alachua County Jail")
      jail.should be_valid
    end
    
    it "must have a long name" do
      jail = FactoryGirl.build(:jail, :full_name => "")
      jail.should_not be_valid
    end
    
    it "should have a unique long name" do
      jail = FactoryGirl.create(:jail, :full_name => "ABC")
      FactoryGirl.build(:jail, :full_name => "ABC").should_not be_valid
    end
   
	end

end
