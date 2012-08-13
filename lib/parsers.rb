module Parsers
  module Alachua
    def parse
      num_downloaded=0
      # time for performance
      start_time = Time.now
      
      # lock file, so we don't run two processes
      lock_file = Rails.root.join('lock', 'alachua.lock')
      
      # check if already locked, and if so, exit rake task
      if File.readable?(lock_file)
        puts "File locked: Exiting and waiting for next go"
        return
      end

      # at this point, we can assume it's open play
      # so we will lock it
      File.open(lock_file, 'w') do |f|
        f.write(Process.pid)
        puts "Created file lock"
      end


      base_url = 'http://oldweb.circuit8.org'
      inmatelist_url = "#{base_url}/inmatelist.php"

      # jail setting
      img_type = "jpg"

      puts "Getting links..."
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
      end
      
      puts "Finished gathering links. #{inmates.length} links gathered."
      #puts "#{inmate_name} #{href} #{bookno} #{mugshot_url}"

      jail = Jails.find_by_short_name("alachua_fl")
      #bookings = Bookings.find_all_by_jail_id(jail.id)

      inmates.each do |inmate|

        # load all current bookings from database into memory, then for each parsed
        # booking, iterate and see if we already have it
        # if so, flag the match_found

#        match_found=false
#        if bookings
#          bookings.each do |b|
#            match_found = true if b.booking_no == inmate[:booking_no]
#          end
#        end
        
        # next iteration of inmates if booking is already in the DB
        # searching by booking no.
        if Bookings.find_by_booking_no(inmate[:booking_no])
          puts "Booking #{inmate[:booking_no]} found for inmate #{inmate[:name]}, skipping..."
          next
        end
        
        
        # we're doing a lot of separate transactions here, so let's wrap this
        # all in a transaction, so if we fail, we won't have partial data
        # clogging the database

        Bookings.transaction do


          
          booking = Bookings.new(
            :inmate_name => inmate[:name],
            :booking_no => inmate[:booking_no],
            :jail_id => jail.id
          )

          # get charge info for the booking

          # load the charge page into nokogiri
          charge_page = Nokogiri::HTML(open(inmate[:booking_url]))

          # get the bond amount
          booking.bond = charge_page.xpath("//table/tr[1]/td[3]").text.match(/\$[\d\,\. ]+/).to_s

          booking_datetime = charge_page.css("table tr td")[9].text.to_s
          # had some issues with the straight dump, so let's process this 
          # more in depth and create a Time object to dump
          # regex for the win!!!
          year = booking_datetime.match(/(?<=\/)[\d]{4}/).to_s
          month = booking_datetime.match(/[\d]+(?=\/)/).to_s
          day = booking_datetime.match(/(?<=\/)[\d]+(?=\/)/).to_s
          hour = booking_datetime.match(/[\d]+(?=:)/).to_s.to_i
          daynight = booking_datetime.match(/[A|P]M/).to_s

          # correct for noon and midnight
          hour += 12 if (daynight == "PM" && hour != 12)
          if hour == 24
            hour = 0
            day = day.to_i
            day+=1
          end
          minute = booking_datetime.match(/(?<=:)[\d]+(?=[A|P])/).to_s

          begin 
            booking.booking_datetime = Time.new(year, month, day, hour, minute)
          rescue => msg
            puts "#{year} #{month} #{day} #{hour} #{minute}"
          end


          if booking.save!

            # an array to hold each charge, then we will go through array
            # and create new Charge objects for each one
            charges = []
            charge_page.css("td").each do |cell|
              if cell.text =~ /^#[\d]*/
                charge = ""
                cell.parent.children.each do |data|
                  charge << ' ' << data.text
                end
                charge = charge.gsub(/#[\d]*/, "").strip
                charges << charge
              end
            end
#                num_tables = charge_page.css("table").length
#                (1...num_tables).each do |n|
#                  charge_table = Nokogiri::HTML(charge_page.css("table")[n].to_s)
#                  charge = charge_table.css("tr")[2].text[3..-1].gsub(/\n/, ' ')
#                  charges << charge
#                end

            raise ActiveRecord::Rollback if charges.empty?

            charges.each do |charge|
              Charges.create!(:charge_name => charge, :booking_id => booking.id)
              #puts "#{booking.id}\t#{charge}"
            end

            DownloadTask.create!(
              :jail_id => jail.id,
              :booking_id => booking.id,
              :remote_filename => inmate[:mugshot_url]
            )
            puts "Saved #{booking.inmate_name}"
            num_downloaded+=1
          end
                 
        end

      end
      
      total_time = Time.now-start_time
      
      time_str = Time.at(total_time).utc.strftime("Parse took %M minutes and %S seconds.")
      puts time_str
      puts "Downloaded #{num_downloaded} bookings out of #{inmates.length}"

      # our work done, remove lock file
      File.delete(lock_file) if File.writable?(lock_file)
  end
    
  end
end