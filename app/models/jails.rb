class Jails < ActiveRecord::Base
  # attr_accessible :title, :body
  
  has_many :bookings
  
  validates :short_name, :presence => true, :uniqueness => true
  validates :full_name, :presence => true, :uniqueness => true
end
