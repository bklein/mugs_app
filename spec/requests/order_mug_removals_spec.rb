require 'spec_helper'

describe "OrderMugRemovals" do
   before(:each) do 
      5.times do 
          jail = FactoryGirl.create(:jail)
          10.times do 
             booking = FactoryGirl.create(:booking, :jail_id => jail.id)
             3.times do
                 charge = FactoryGirl.create(:charge, :booking_id => booking.id)
             end
          end
      end
   end
  
  describe "removes with valid credit card" do
    it "should take order with valid CC" do
      booking = Bookings.first
      booking.should_not be_nil
    
      jail = Jails.find(booking.jail_id)

      visit jail_booking_path(jail, booking)
      click_link "Remove"
      
      fill_in 'order_email', :with => "test@test.com"
      fill_in 'Credit Card', :with => "4141414141414141"
      fill_in 'CCV', :with => '123'
      select 'October', :from => 'card_month'
      select '2013', :from => 'card_year'

      click_button "Purchase"

      page.should have_content("Confirm purchase")
      click_button "Confirm purchase"

      page.should have_content("Thank you")
      page.should have_content("Return to Home Page")

      @booking = Bookings.find(@booking.id) #reload model

      @booking.is_purchased.should be_true

      visit jail_booking_path(@jail, @booking)
      page.should have_content("The requested resource is unavailable")
    end
  end
  
end
