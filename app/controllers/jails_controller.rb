class JailsController < ApplicationController

	def index
		@jails = Jails.all
	end
	
  def show
      @jail = Jails.find(params[:id])
      @bookings = Bookings.find_all_by_jail_id(params[:id], :conditions => ['is_purchased = ?', false])
  end
	

end
