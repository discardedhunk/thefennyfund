ORDERMAILER_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/order_mailer.yml")[RAILS_ENV]

class OrderMailer < ActionMailer::Base
  def new_order_email(order)
    puts "\nORDER_MAILER??\n"
    customer = Customer.find(order.customer_id)
    recipients    customer.email
    from          "The Fenny Fund <tschiffer@thefennyfund.com>"
    cc            ORDERMAILER_CONFIG['cc_email']
    subject       "Thanks for you order!!"
    sent_on       Time.now
    body          :customer => customer, :order => order
    default_url_options[:host] = "thefennyfund.heroku.com"
    default_url_options[:protocol] = "https"
  end

end
