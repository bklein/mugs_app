class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new
    @order.booking_id = params[:id]
    @booking = Bookings.find_by_id(params[:id])
    @order.inmate_name = @booking.inmate_name
    @order.booking_id = @booking.id
    @order.remote_ip = request.remote_ip
    if @booking.nil?
      redirect_to root_url, :notice => "Booking not found!"
    end
    
    # render new.html.erb
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])
    
    if @order.save
      render 'confirm'
    end
    
  end
  
  # confirm purchase
  def confirm
    @order = Order.find(params[:id])
    
    charge = Stripe::Charge.create(
      :amount => 10000,
      :currency => 'usd',
      :card => @order.stripe_card_token,
      :description => "#{@order.booking_id} - #{@order.inmate_name} - #{@order.email}"
    )
    
    @order.is_complete = true
    @booking = Bookings.find(@order.booking_id)
    @booking.is_purchased = true
    
    @order.save
    @booking.save
    
    render 'thank_you'
  end
  
  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end
