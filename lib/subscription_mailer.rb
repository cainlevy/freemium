class SubscriptionMailer < ActionMailer::Base
  self.template_root = File.dirname(__FILE__)

  def invoice(user, subscription, amount)
    setup_email(user)
    @subject              = "Your Invoice"
    @body[:amount]        = amount
    @body[:subscription]  = subscription
    @bcc                  = Freemium.admin_report_recipients if Freemium.admin_report_recipients
  end

  def expiration_warning(user, subscription)
    setup_email(user)
    @subject              = "Your subscription is set to expire"
    @body[:subscription]  = subscription
    @bcc                  = Freemium.admin_report_recipients if Freemium.admin_report_recipients
  end

  def expiration_notice(user, subscription)
    setup_email(user)
    @subject              = "Your subscription has expired"
    @body[:subscription]  = subscription
    @bcc                  = Freemium.admin_report_recipients if Freemium.admin_report_recipients
  end

  def admin_report(admin, activity_log)
    setup_email(admin)
    @subject              = "Freemium admin billing report"
    @body[:log]           = activity_log
  end

  protected

  def setup_email(user)
    @recipients  = "#{user.respond_to?(:email) ? user.email : user}"
    @from        = "billing@example.com"
    @sent_on     = Time.now
    @body[:user] = user
  end
end
