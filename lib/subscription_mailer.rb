class SubscriptionMailer < ActionMailer::Base
  self.template_root = File.dirname(__FILE__)

  def invoice(user, subscription, amount)
    setup_email(user)
    @subject              = "Your Invoice"
    @body[:amount]        = amount
    @body[:subscription]  = subscription
  end

  def expiration_warning(user, subscription)
    setup_email(user)
    @subject              = "Your subscription is set to expire"
    @body[:subscription]  = subscription
  end

  def expiration_notice(user, subscription)
    setup_email(user)
    @subject              = "Your subscription has expired"
    @body[:subscription]  = subscription
  end

  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "billing@example.com"
    @sent_on     = Time.now
    @body[:user] = user
  end
end
