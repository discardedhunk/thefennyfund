class OrderMailer < ActionMailer::Base
  def new_order_email(order)
    puts "\nORDER_MAILER??\n"
    customer = Customer.find(order.customer_id)
    recipients    customer.email
    from          "The Fenny Fund <tschiffer@thefennyfund.com>"
    subject       "Thanks for you order!!"
    sent_on       Time.now
    body          :customer => customer, :order => order, :host => "https://thefennyfund.heroku.com"
  end

end
