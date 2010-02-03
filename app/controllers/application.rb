# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "store"
  before_filter :require_ssl, :authorize, :except => [:login]
  #before_filter :record_prev_uri
  after_filter :record_prev_uri
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => '207ee8d365cf9664881e66979452e358'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  

  protected
    def authorize
      #if request.path_parameters[:controller] == 'users' or request.path_parameters[:controller] == 'products' or request.path_parameters[:controller] == 'orders' or request.path_parameters[:controller] == 'admin' or (request.path_parameters[:controller] == 'customers' and (request.path_parameters[:action] == 'show' or request.path_parameters[:action] == 'index'))
      logger.debug "\n path_params_controller = #{request.path_parameters[:controller]}\n"
      if request.path_parameters[:controller].include?('admin')
        logger.debug "\n path_params2 = #{request.path_parameters[:controller]}"
        unless User.find_by_id(session[:user_id]) or ( User.count.zero? and (request.path_parameters[:controller].include?('users') and (request.path_parameters[:action] == 'new' or request.path_parameters[:action] == 'create')))
          session[:original_uri] = request.request_uri
          flash[:notice] = "Please log in"
          redirect_to :controller => 'admin', :action => 'login'
        end
      elsif request.request_uri.include?("customers")
        unless Customer.find_by_id(session[:customer_id]) or ( request.path_parameters[:controller] == 'customers' and ( request.path_parameters[:action] == 'new' or request.path_parameters[:action] == 'create' ) ) or User.find_by_id(session[:user_id])
          session[:original_uri] = request.request_uri
          flash[:notice] = "Please log in"
          redirect_to :controller => 'customers', :action => 'login'
        end
      end
    end

    def record_prev_uri
      @prev_uri = request.request_uri
      logger.debug "\nprev_uri= #{@prev_uri}\n"
    end

    def require_ssl
      redirect_to :protocol => "https://" unless (request.ssl? or local_request?)
    end
    
end
