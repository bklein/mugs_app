require 'spec_helper'

describe "ViewMugsNavigations" do
  
  describe "viewing the home page" do 
    
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
   

    it "should display a select of jails available" do
      @jails = Jails.find(:all)
      visit root_path
      page.should have_content("Select a jail")
      @jails.each do |j|
        page.should have_content(j.full_name)
      end
      
    end
    
    it "should click on jail name and take to jail page with bookings" do
      
      visit root_path
      
      jail = Jails.first
      
      click_link jail.full_name
      #save_and_open_page
      page.should have_content(jail.full_name)
      
      @bookings = Bookings.find_all_by_jail_id(jail.id)
      @bookings.each do |b|
        page.should have_content(b.inmate_name)
        
        
      end
      
    end
    
    it "should click on mugshot and take to individual mugshot page" do
      jail = Jails.first
      
      visit jail_path(jail)
      
      booking = Bookings.first
      # save_and_open_page
      click_link find(:xpath, "//a[contains(@href, #{booking.id})]")
      
      @charges = Charges.find_all_by_booking_id(booking.id) 
      @charges.each do |charge| 
        page.should have_content(charge.charge_name)
      end
      
      page.should have_link("Click to remove")
     
     
    end
    
    it "should let you order a mug removal" do
      visit new_order_path
      
    end
  end
end
