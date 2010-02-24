class ProductsController < ApplicationController

  # GET /products/1
  # GET /products/1.xml
  def show

    @product = Product.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end

    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      flash[:notice] = 'Product ID not found!'
      redirect_to root_url

  end

end
