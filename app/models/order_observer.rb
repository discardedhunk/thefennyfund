class OrderObserver < ActiveRecord::Observer
  def after_save(order)
    OrderMailer.deliver_new_order_email(order)
  end
end
