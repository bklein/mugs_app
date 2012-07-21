require 'open-uri'
require 'digest'

namespace :parse do

	desc "Parse Alachu County Jail"
	task :alachua => :environment do
    base_url = 'http://oldweb.circuit8.org'
		inmatelist_url = "#{base_url}/inmatelist.php"
    
    # jail setting
    img_type = "jpg"
    
		
    doc = Nokogiri::HTML(open(inmatelist_url))
		
    inmates = []		
		
    links = doc.xpath("//a[contains(@href, '/cgi-bin/jaildetail.cgi?bookno=')]")
		links.each do |link|
			name = link.text.strip.split(',')
			href = link['href']
			first_name = name.last.strip
			last_name = name.first.strip
			inmate_name = "#{first_name} #{last_name}"
			bookno = href[31..-1]
      mugshot_url = "#{base_url}/cgi-bin/mugshot.cgi?bookno=#{bookno}"
      booking_url = "#{base_url}/cgi-bin/jaildetail.cgi?bookno=#{bookno}"
			
      inmate = {
        :name => inmate_name,
        :mugshot_url => mugshot_url,
        :booking_url => booking_url,
        :booking_no => bookno
      }
      
      inmates << inmate
      
      #puts "#{inmate_name} #{href} #{bookno} #{mugshot_url}"
      
      jail = Jails.find_by_short_name("alachua_fl")
      bookings = Bookings.find_all_by_jail_id(jail.id)
      
      inmates.each do |inmate|
        match_found=false
        if bookings
          bookings.each do |b|
            match_found = true if b.booking_no == inmate[:booking_no]
          end
        end
        if !match_found
          booking = Bookings.new(
            :inmate_name => inmate[:name],
            :booking_no => inmate[:booking_no],
            :jail_id => jail.id
          )
          
         
          if booking.save!
            puts "Saved"
            local_filename = "#{Digest::SHA1.hexdigest(booking.booking_no)}.#{img_type}"
            DownloadTask.create(
              :jail_id => jail.id,
              :booking_id => booking.id,
              :remote_filename => inmate[:mugshot_url],
              :local_filename => local_filename
            )
            
          end
        end          
#          
        
#        
#        booking = Bookings.find_by_booking_no(inmate[:booking_no])
#        if booking.nil?
#          booking = Bookings.new(
#            :inmate_name => inmate[:name],
#            :booking_no => inmate[:booking_no],
#            :jail_id => @jail.id
#          )          
#          
          # do charge parsing and add mugshot to image job cron list
          # update booking model and charges models
        
          
        
      end
      
		end
		
		puts "alachua test #{inmates.length}"
	end
end
