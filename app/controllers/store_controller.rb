require 'net/http'
require 'net/https'
require 'uri'

class StoreController < ApplicationController
  
  before_filter :require_ssl, :find_cart, :except => :empty_cart

  ID_TOKEN = "Cb93BAgmMAw3tuwT3N-iyXiQwX7dSxSptsC_N5Iv_sbAci53_oPmECIeU2u"
  PAYPAL_URL = 'www.paypal.com'
  PAYPAL_PATH = '/cgi-bin/webscr'

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

  def add_all_to_cart()
    products = Product.all()
    for product in products
      @cart.add_product(product)
    end
    redirect_to_index
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
    session[:pp_verified] = false
    unless Customer.find_by_id(session[:customer_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      puts "\nREDIRECTING TO CUST LOGIN\n"
      redirect_to :controller => 'customers', :action => 'login'
    end
    
    if params[:order]
      logger.debug("\nSAVING??\n")
      logger.debug("ORDER_PARAMS: #{params[:order].to_s}")
      save_order
    else
      if @cart.items.empty?
        redirect_to_index("Your cart is empty")
      else
        logger.debug("\n NEW ORDER?\n")
        @order = Order.new
        @total = @cart.total_price
      end
    end 
  end
  
  def paypal_verify
    customer = Customer.find_by_id(session[:customer_id])
    if customer
      tx_id = params[:tx]

      http = Net::HTTP.new(PAYPAL_URL, 443)
      http.use_ssl = true

      data = "cmd=_notify-synch&tx=#{tx_id}&at=#{ID_TOKEN}"
      resp, data = http.post(PAYPAL_PATH, data)
      logger.debug "\nCode = #{resp.code}\n"
      logger.debug "\nMessage = #{resp.message}\n"
      resp.each {|key, val| puts key + ' = ' + val}
      logger.debug "\nDATA= #{data}\n"

      data.gsub!(/\n/, '<br/>')

      if data.include?("SUCCESS") && data.include?(tx_id)
        @msg = "PayPal response:<br/><br/>" + data
        params[:order] = {"pay_type"=>"paypal"}
        if session[:pp_verified] == false
          save_order(:pp_tx_id => tx_id)
          flash[:notice] = "Thanks for your order!"
        end
        @last_order = Order.find_by_pp_tx_id(tx_id)
        session[:pp_verified] = true
      else
        flash[:notice] = "Oops, something went wrong!"
        @msg = "PayPal response:<br/><br/>#{data}"
        session[:pp_verified] = false
      end
    else
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      puts "\nREDIRECTING TO CUST LOGIN\n"
      redirect_to :controller => 'customers', :action => 'login'
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
    
    def save_order(opts={})
      @order = Order.new(params[:order])
      @order.customer_id = session[:customer_id]
      logger.debug "\nOPTS= #{opts}"
      if opts[:pp_tx_id]
        @order.pp_tx_id = opts[:pp_tx_id]
      end
      @order.add_line_items_from_cart(@cart) 
      if @order.save
        session[:cart] = nil
        #redirect_to("Thank you for your order")
      else
        render :action => 'checkout'
      end 
    end

    def require_ssl
      redirect_to :protocol => "https://" unless (request.ssl? or local_request?)
    end

end
