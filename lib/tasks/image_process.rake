require 'open-uri'

namespace :image do
  
  task :download => :environment do
    
    
    #@downloads = DownloadTask.all(:conditions => ["is_downloaded = ?", false], :limit => 10)
    @downloads = DownloadTask.all
    
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
            puts "Error on saving #{download.remote_filename}: #{msg}"
          end
        end




        puts "Downloaded #{download.remote_filename} for ID #{@booking.id}"
      end
    end
  end
  
end