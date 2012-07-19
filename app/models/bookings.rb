class Bookings < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :mugshot
 	belongs_to :jail
 	has_many :charges
 	
  mount_uploader :mugshot, MugshotUploader
 	
 	validates :inmate_name, :presence => true
 	validates :booking_no, :presence => true
 	validates :bond, :numericality => {:greater_than_or_equal_to => 0}
 	
end
