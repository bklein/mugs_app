class JailsController < ApplicationController

	def index
		@jails = Jails.all
	end
	
  def show
      @jail = Jails.find(params[:id])
      @bookings = Bookings.where(
        'jail_id = ? AND is_purchased = ? AND is_downloaded = ?',
         params[:id], false, true).order("booking_datetime DESC").page(params[:page]).per(10)
  end
	

end
