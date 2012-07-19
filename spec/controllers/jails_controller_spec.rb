require 'spec_helper'

describe JailsController do

	describe "GET index" do
		it "assigns all jails to @jails" do
			jail = FactoryGirl.create(:jail, :short_name => "alachua_county")
			get :index
			assigns(:jails).should eq([jail])
		end
	end

end
