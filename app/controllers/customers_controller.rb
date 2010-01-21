class CustomersController < ApplicationController
  # GET /customers
  # GET /customers.xml
  
  def index
    redirect_to(root_url)
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    if session[:customer_id]
      logger.debug("in cust_controller show")
      cust_id = session[:customer_id]
      @customer = Customer.find(cust_id)

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @customer }
      end
    else
      flash.now[:notice] = "Please Login"
    end   
  end

  # GET /customers/new_customer
  # GET /customers/new.xml
  def new
    @customer = Customer.new
    @customer_email = session[:customer_email]
    session[:customer_email] = nil
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(session[:customer_id])
  end

  # POST /customers
  # POST /customers.xml
  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        flash[:notice] = 'Customer was successfully created.'
        format.html { redirect_to :controller => 'customers', :action => 'login' }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        flash[:notice] = 'Customer was successfully updated.'
        format.html { redirect_to(@customer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /customers/login
  # GET /customers/login.xml
  def login

    puts "\nIN CUST LOGIN\n"

    if request.get?
      flash[:notice] = nil
    elsif request.post?
      if params[:new_cust] == "true"
        session[:customer_email] = params[:email]
        redirect_to :controller => "customers", :action => "new"
      end
      customer = Customer.authenticate(params[:email], params[:password])
      if customer
        session[:customer_id] = customer.id
        session[:customer_name] = customer.first_name
        uri = session[:original_uri]
        logger.debug("orig_url= #{uri}")
        session[:original_uri] = nil
        redirect_to(uri || root_url )
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:customer_id] = nil
    session[:customer_name] = nil
    flash[:notice] = "Logged out"
    redirect_to('/store/')
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
      format.xml  { head :ok }
    end
  end
end
