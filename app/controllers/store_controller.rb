require 'paypal_stuff/pdt'

class StoreController < ApplicationController

  PAYPAL_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/paypal.yml")[RAILS_ENV]
  
  before_filter :require_ssl, :find_cart, :except => :empty_cart

  def initialize
    @categories = Category.find(:all)
  end

  def index()
    session[:return_to] = request.request_uri
    @sounds = []
    @category = nil
    if params[:category]
      @category = params[:category]
    end

    @products = Product.find_products_for_sale(@category)
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @products.to_xml() }
    end
  end

  def show

    @product = Product.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @products.to_xml() }
    end
  end
  
  def add_to_cart()
    if params[:group]
      group = params[:group]
      @current_item = @cart.add_product_group(group)
    else
      product = Product.find(params[:id])
      @count = reset_count
      @current_item = @cart.add_product(product)
    end
    
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
    @pp_form_url = PAYPAL_CONFIG['form_url']
    @pp_business = PAYPAL_CONFIG['business']
    @pp_cmd = PAYPAL_CONFIG['cmd']
    @pp_item = PAYPAL_CONFIG['item_name']

    logger.debug "\nIN CHECKOUT\n"
    logger.debug "\npp_form_url= #{@pp_form_url+@pp_cmd}\n"
    logger.debug "\npp_business= #{@pp_business}"
    session[:pp_verified] = false
    unless Customer.find_by_id(session[:customer_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to :controller => 'customers', :action => 'login'
    end
    
    if params[:order]
      logger.debug("\nSAVING ORDER\n")
      logger.debug("ORDER_PARAMS: #{params[:order].to_s}")
      save_order
    else
      if @cart.items.empty?
        redirect_to_index("Your cart is empty")
      else
        logger.debug("\nNEW ORDER\n")
        @order = Order.new
        @total = @cart.total_price
      end
    end 
  end
  
  def paypal_verify
    customer = Customer.find_by_id(session[:customer_id])
    if customer
      tx_id = params[:tx]

      success,msg = PaypalStuff::Pdt.pdt_verify(tx_id)
      @msg = msg
      if success
        params[:order] = {"pay_type"=>"paypal"}
        if session[:pp_verified] == false
          save_order(:pp_tx_id => tx_id)
          flash[:notice] = "Thanks for your order!"
        end
        @last_order = Order.find_by_pp_tx_id(tx_id)
        session[:pp_verified] = true
      else
        flash[:notice] = "Oops, something went wrong!"
        session[:pp_verified] = false
      end

    else
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
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
      @order.total = @cart.total_price
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
