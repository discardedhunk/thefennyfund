class StoreController < ApplicationController
  
  before_filter :find_cart, :except => :empty_cart
  
  def index()
    @current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    @products = Product.find_products_for_sale
    @display_count = nil
    @count = increment_count
    if @count > 5
      @display_count = @count
    end
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @products.to_xml() }
    end
  end
  
  def add_to_cart()
    product = Product.find(params[:id]) 
    @count = reset_count
    @current_item = @cart.add_product(product)
      respond_to do |format|
        format.js if request.xhr?
        format.html {redirect_to_index}
      end
    rescue ActiveRecord::RecordNotFound 
      logger.error("Attempt to access invalid product #{params[:id]}") 
      redirect_to_index("Invalid product") 
  end
  
  def empty_cart()
    session[:cart] = nil 
    redirect_to_index unless request.xhr?
  end
  
  def remove_from_cart()
    @current_item = @cart.remove_product(params[:id])
    if @current_item != nil
      respond_to do |format| 
        format.js if request.xhr?
        format.html {redirect_to_index}
      end    
    else
      logger.error("EE :: Item not in cart #{params[:id]}")
      redirect_to_index
    end
  end
  
  def checkout()

    puts "\nIN CHECKOUT\n"

    unless Customer.find_by_id(session[:customer_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      puts "\nREDIRECTING TO CUST LOGIN\n"
      redirect_to :controller => 'customers', :action => 'login'
    end

    if params[:order]
      save_order
    else
      if @cart.items.empty?
        redirect_to_index("Your cart is empty")
      else
        @order = Order.new
      end
    end 
  end
  
  
  
  def cancel_order
    redirect_to_index("Your order has been cancelled")
  end
  
  protected
    def authorize
    end
  
  private
    
    def find_cart()
      @cart = (session[:cart] ||= Cart.new)
    end
  
    def redirect_to_index(msg = nil) 
      flash[:notice] = msg 
      redirect_to :action => 'index'
    end
  
    def increment_count
      if session[:counter].nil?
        session[:counter] = 0
      end
      
      session[:counter] += 1
    end
  
    def reset_count
      session[:counter] = 0
    end
    
    def save_order 
      @order = Order.new(params[:order])
      @order.customer_id = session[:customer_id]
      @order.add_line_items_from_cart(@cart) 
      if @order.save
        session[:cart] = nil
        redirect_to_index("Thank you for your order")
      else
        render :action => 'checkout'
      end 
    end

end
