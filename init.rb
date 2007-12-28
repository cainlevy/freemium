# todo: use autoloading instead
require 'money'
require 'subscription'
require 'subscription_mailer'
require 'subscription_plan'
require 'freemium'
require 'freemium/transaction'
require 'freemium/gateways/base'
require 'freemium/gateways/test'
require 'freemium/manual_billing'
require 'freemium/recurring_billing'

# default config. yes, this should happen somewhere else. i'll do that later.
Freemium.mailer     = SubscriptionMailer
Freemium.gateway    = Freemium::Gateways::Test.new
Freemium.days_grace = 3
Subscription.send(:include, Freemium.manual_billing ? Freemium::ManualBilling : Freemium::RecurringBilling)