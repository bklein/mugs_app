require 'open-uri'

namespace :image do
  
  task :download => :environment do
    
    
    #@downloads = DownloadTask.all(:conditions => ["is_downloaded = ?", false], :limit => 10)
    @downloads = DownloadTask.all(:limit => 100)
    
    @downloads.each do |download|
      
      filename = Rails.root.join('image_workspace', download.local_filename)
      
      
      
#      File.open(filename, 'wb') do |f|
#        f.write open(download.remote_filename, 'rb')
#      end
#     
      @booking = Bookings.find(download.booking_id)
      @booking.remote_mugshot_url = download.remote_filename
      @booking.save
      
      download.is_downloaded = true;
      download.save
      
      puts "Downloaded #{download.remote_filename} for ID #{@booking.id}"
    end
    
  end
  
end