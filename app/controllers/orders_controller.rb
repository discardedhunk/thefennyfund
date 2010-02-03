class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.find_all_by_customer_id(session[:customer_id])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    logger.debug "\norders_controller_show request_uri= #{request.request_uri}"
    session[:prev_uri] = request.request_uri
    @order = Order.find(params[:id])
    if @order and @order.customer_id == session[:customer_id]
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @order }
      end
    else
      logger.error("Attempt to access order not for customer! #{params[:id]}")
      flash[:notice] = 'Order not found!'
      redirect_to customer_orders_url(session[:customer_id])
    end
    
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid order #{params[:id]}")
      flash[:notice] = 'Order not found!'
      redirect_to customer_orders_url(session[:customer_id])
  end
=begin
  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml

  def create
    @order = Order.new(params[:order])
    @order.customer_id = session[:customer_id]
    puts "\norder = #{@order}\n"
    respond_to do |format|
      if @order.save
        flash[:notice] = 'Order was successfully created.'
        format.html { redirect_to(@order) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    puts "\nHUH?????\n"
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        flash[:notice] = 'Order was successfully updated.'
        format.html { redirect_to(@order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
=end

end
