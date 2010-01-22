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

  validates_presence_of  :pay_type
  validates_inclusion_of :pay_type, :in =>
    PAYMENT_TYPES.map {|disp, value| value}

  def add_line_items_from_cart(cart)
    cart.items.each do |item|
      li = LineItem.from_cart_item(item)
      line_items << li
    end
  end

end
