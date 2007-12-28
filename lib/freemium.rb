module Freemium
  class << self
    # Lets you configure which ActionMailer class contains an appropriate
    # "invoice" method/template. This method should imitate the provided
    # invoicer: SubscriptionMailer#invoice
    attr_accessor :mailer

    # The gateway of choice. Default gateway is a stubbed testing gateway.
    attr_accessor :gateway

    # Whether or not to enable manual billing. Note that billing will still be
    # automatic for *you*, but the question is whether Freemium itself should
    # manually bill subscriptions or rely on the gateway's automated recurring
    # billing module.
    attr_accessor :manual_billing

    # How many days to keep an account active after it fails to pay.
    attr_accessor :days_grace
  end
end