class OrderMailer < ActionMailer::Base
  def new_order_email(order)
    puts "\nORDER_MAILER??\n"
    customer = Customer.find(order.customer_id)
    recipients    customer.email
    from          "The Fenny Fund <tschiffer@thefennyfund.com>"
    subject       "Thanks for you order!!"
    sent_on       Time.now
    body          :customer => customer, :url => "https://thefennyfund.heroku.com/store/customers/login"
  end

end
