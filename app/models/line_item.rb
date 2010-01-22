# == Schema Information
# Schema version: 20100119154802
#
# Table name: line_items
#
#  id          :integer         not null, primary key
#  product_id  :integer         not null
#  order_id    :integer         not null
#  quantity    :integer         not null
#  total_price :decimal(8, 2)   not null
#  created_at  :datetime
#  updated_at  :datetime
#

class LineItem < ActiveRecord::Base

  belongs_to :order
  belongs_to :product

  def self.from_cart_item(cart_item)
    li = self.new
    li.product = cart_item.product
    li.quantity = cart_item.quantity
    li.total_price = cart_item.price
    li
  end
  
end
