class AdminController < ApplicationController

  def login
    if request.get? and User.count.zero?
      flash[:notice] = "Create your first administrator account."
      redirect_to(new_admin_user_url)
    elsif request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        #uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to("/admin")
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

  def index
    @total_orders = Order.count
  end

end
