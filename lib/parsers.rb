require 'open-uri'
require 'digest'

class ImageDownloader
  def self.download logfile
        #@downloads = DownloadTask.all(:conditions => ["is_downloaded = ?", false], :limit => 10)
    f = File.open(logfile, 'a+') # log things to passed log file location
    
    @downloads = DownloadTask.all
    
    start_time = Time.now
    
    @downloads.each do |download|
      
     # filename = Rails.root.join('image_workspace', download.local_filename)
      
      
      
#      File.open(filename, 'wb') do |f|
#        f.write open(download.remote_filename, 'rb')
#      end
#     
      @booking = Bookings.find(download.booking_id)
      if @booking
        

        ActiveRecord::Base.transaction do
          begin 
            @booking.remote_mugshot_url = download.remote_filename        
            @booking.is_downloaded = true
            @booking.save!
            download.destroy
          rescue => error_msg
            msg = error_msg.backtrace.join("\n")
            f.puts "Error on saving #{download.remote_filename}: #{msg}"
          end
        end



        f.puts "Downloaded #{download.remote_filename} for ID #{@booking.id}"
      end
    end
    time = Time.now - start_time
    timestr = Time.at(time).utc.strftime("Downloads took %M minutes and %S secs.")
    f.puts timestr
    f.close
  end
end


class AlachuaParser
  def self.parse logfile
    num_downloaded=0
    # time for performance
    start_time = Time.now
    num_skipped = 0

    base_url = 'http://oldweb.circuit8.org'
    inmatelist_url = "#{base_url}/inmatelist.php"

    f = File.open(logfile, 'a+')
    # jail setting
    img_type = "jpg"
    f.puts "Start time: #{Time.now}"
    f.puts "Getting links..."
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

    f.puts "Finished gathering links. #{inmates.length} links gathered."
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
        # puts "Booking #{inmate[:booking_no]} found for inmate #{inmate[:name]}, skipping..."
        num_skipped += 1
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
          f.puts "Error on date #{year} #{month} #{day} #{hour} #{minute}"
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

          if charges.empty?
            f.puts "Skipping #{inmate[:name]} due to empty charges (too soon?)"
            raise ActiveRecord::Rollback
          end
          

          charges.each do |charge|
            if charge.length < 5
              f.puts "Skipping #{inmate[:name]} due to malformed charge (too soon?)"
              raise ActiveRecord::Rollback
            end
            Charges.create!(:charge_name => charge, :booking_id => booking.id)
            #puts "#{booking.id}\t#{charge}"
          end

          DownloadTask.create!(
            :jail_id => jail.id,
            :booking_id => booking.id,
            :remote_filename => inmate[:mugshot_url]
          )
          f.puts "Saved #{booking.inmate_name}"
          num_downloaded+=1
        end

      end

    end

    total_time = Time.now-start_time

    time_str = Time.at(total_time).utc.strftime("Parse took %M minutes and %S seconds.")
    f.puts time_str
    f.puts "Downloaded #{num_downloaded} bookings out of #{inmates.length}, #{num_skipped} skipped."
    f.puts "End time #{Time.now}"
    f.close
  end
end

