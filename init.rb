# depends on the Money gem
require 'money'

# default config. yes, this should happen somewhere else. i'll do that later.
Freemium.mailer     = SubscriptionMailer
Freemium.gateway    = Freemium::Gateways::Test.new
Freemium.days_grace = 3
Subscription.send(:include, Freemium.manual_billing ? Freemium::ManualBilling : Freemium::RecurringBilling)