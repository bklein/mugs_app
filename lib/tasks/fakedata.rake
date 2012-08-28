require 'faker'

namespace :jail do
	task :fill => :environment do 
    
    # erase databases first
    
    [Jails, Bookings, Charges].each(&:delete_all)
		
	
		puts "Creating fake jails..."
		3.times do |i|
			jail = Jails.new
			jail.short_name = "jail_#{i}"
      jail.full_name = "Jail Number #{i}"
			jail.save!
			puts "\nCreating jobs (Jail #{i})..."
		
			30.times do |n|
        print "."
				booking = Bookings.new
				booking.inmate_name = Faker::Name.name
				booking.bond = Random.new.rand(100000)
				booking.booking_no = "ASO0000000#{n}"
				booking.jail_id = jail.id
        filename = "avatar_" + [1,2,3,4].sample.to_s + ".jpg"
        booking.mugshot = File.open(Rails.root.join("spec", "files", filename))
				booking.save!
			
		
				3.times do 
          # puts "Planting the evidence..."
					charge = Charges.new
					charge.charge_name = Faker::Company.catch_phrase
					charge.booking_id = booking.id
					charge.save!
				end	
			end
		end
    puts "\nFinished!"
	end				
end
