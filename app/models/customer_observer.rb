class CustomerObserver < ActiveRecord::Observer
  def after_create(customer)
    CustomerMailer.deliver_welcome_email(customer)
  end
end
