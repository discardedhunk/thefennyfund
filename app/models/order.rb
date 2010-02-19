# == Schema Information
# Schema version: 20100119154802
#
# Table name: orders
#
#  id          :integer         not null, primary key
#  pay_type    :string(10)
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer         not null
#

class Order < ActiveRecord::Base

  has_many :line_items
  belongs_to :customer

  PAYMENT_TYPES = [
    # Displayed         stored in db
    [ "PayPal", "paypal" ]
  ]

  validates_uniqueness_of :pp_tx_id, :message => "That PayPal Transaction ID already exists!"
  validates_presence_of  :pay_type
  validates_inclusion_of :pay_type, :in =>
    PAYMENT_TYPES.map {|disp, value| value}

  def add_line_items_from_cart(cart)
    cart.items.each do |item|
      if item.group
        group = Group.find_by_name(item.group)
        products = Product.find_all_by_group_id(group.id)
        for product in products
          citem = CartItem.new(product)
          citem.quantity = item.quantity
          li = LineItem.from_cart_item(citem)
          line_items << li
        end
      else
        li = LineItem.from_cart_item(item)
        line_items << li
      end
    end
  end

end
