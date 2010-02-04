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

end
