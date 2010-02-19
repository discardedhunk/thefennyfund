class Cart
  attr_reader :items
  
  def initialize 
    @items = []
  end

  def add_product(product, group=false)
    current_item = @items.find {|item| item.product == product} 
    if current_item
      current_item.increment_quantity
    else
      current_item = CartItem.new(product)
      if group
        current_item.group=(group)
      end
      @items << current_item
    end
    current_item
  end

  def add_product_group(group_name)
    discount_amount = 0
    group = Group.find_by_name(group_name)
    products = Product.find_all_by_group_id(group.id)
    prod_total = products.sum { |product| product.price }
    if group.discount > 0.00
      discount_amount = prod_total * group.discount
    end

    group_product = @items.find {|item| item.product.title == "#{group.name}"}
    if group_product
      group_product.increment_quantity
      current_item = group_product
    else
      group_product = Product.new
      group_product.id = "#{group.name}"
      group_product.title = "#{group.name}"
      price = prod_total - discount_amount

      group_product.price = (price * 10**2).round.to_f / 10**2
      current_item = add_product(group_product, group.name)
    end
    current_item

  end
  
  def remove_product(product)
    current_item = @items.find {|item| item.id == product.to_i}
    if current_item
      current_item.decrement_quantity
      @items.delete(current_item) if current_item.quantity == 0
    end
    current_item
  end
  
  def total_price 
    @items.sum { |item| item.price }
  end
  
  def total_items 
    @items.sum { |item| item.quantity }
  end
  
end