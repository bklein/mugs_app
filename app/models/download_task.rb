class DownloadTask < ActiveRecord::Base
  attr_accessible :booking_id, :is_downloaded, :is_processed, :jail_id, :local_filename, :remote_filename
end
