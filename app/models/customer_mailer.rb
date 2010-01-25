class CustomerMailer < ActionMailer::Base
  def welcome_email(customer)
    recipients    customer.email
    from          "The Fenny Fund <tschiffer@thefennyfund.com>"
    subject       "Welcome to The Fenny Fund Store!"
    sent_on       Time.now
    body          :customer => customer, :url => "https://thefennyfund.heroku.com/store/customers/login"
  end

end
