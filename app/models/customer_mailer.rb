class CustomerMailer < ActionMailer::Base
  def welcome_email(customer)
    recipients    customer.email
    from          "My Awesome Site Notifications <notifications@example.com>"
    subject       "Welcome to My Awesome Site"
    sent_on       Time.now
    body          :customer => customer, :url => "https://thefennyfund.heroku.com/store/customers/login"
  end

end
