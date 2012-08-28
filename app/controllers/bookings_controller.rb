class BookingsController < ApplicationController
  before_filter :get_jail
  
  def show
    @booking = Bookings.find_by_id(params[:id])
    @charges = Charges.find_all_by_booking_id(params[:id])
  end
  
  private
  
  def get_jail
    @jail = Jails.find(params[:jail_id])
  end
end
