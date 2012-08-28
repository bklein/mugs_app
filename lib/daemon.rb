# daemon.rb
# contains the parsing functions and image download functions
# that were previously in rake tasks
# designed to run continuously (with timed delay between runs)
# with exception handling for stability


require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'environment.rb'))

require Rails.root.join('lib', 'parsers.rb')

imagelog = Rails.root.join('log', 'imagelog.log')
parserlog = Rails.root.join('log', 'parserlog.log')
# the delay between runs in seconds
#delay_time = 5*60
delay_time = 1

alachua = AlachuaParser.new(parserlog)
downloader = ImageDownloader.new imagelog

while true do 
  begin
    alachua.parse
  rescue
  end
  
  begin 
    downloader.download
  end
  
  
  sleep delay_time
end




