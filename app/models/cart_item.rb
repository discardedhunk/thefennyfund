class CartItem
  attr_reader :product, :quantity

  def initialize(product) 
    @product = product 
    @quantity = 1
  end

  def increment_quantity 
    @quantity += 1
  end
  
  def decrement_quantity
     @quantity -= 1 if @quantity > 0
  end

  def quantity=(val)
    @quantity = val
  end

  def title 
    @product.title
  end

  def price 
    @product.price * @quantity
  end
  
  def id
    @product.id
  end

  def group=(val)
    @group = val
  end

  def group
    @group
  end
  
end