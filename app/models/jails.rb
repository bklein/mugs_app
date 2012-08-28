class Jails < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :short_name, :full_name
  
  has_many :bookings
  
  validates :short_name, :presence => true, :uniqueness => true
  validates :full_name, :presence => true, :uniqueness => true
end
