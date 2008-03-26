module Freemium
  class << self
    # Lets you configure which ActionMailer class contains appropriate
    # mailings for invoices, expiration warnings, and expiration notices.
    # You'll probably want to create your own, based on lib/subscription_mailer.rb.
    attr_writer :mailer
    def mailer
      @mailer ||= SubscriptionMailer
    end

    # The gateway of choice. Default gateway is a stubbed testing gateway.
    attr_writer :gateway
    def gateway
      @gateway ||= Freemium::Gateways::Test.new
    end

    # If you want all of the billing to be initiated by Freemium.
    #
    # Check whether this option is available for your gateway of choice.
    # Note that either this or enable_arb_integration must be called for proper setup.
    def fully_controlled_billing
      Subscription.send(:include, Freemium::ManualBilling)
    end

    # If you want the monthly cycles to be handled by your gateway's automated
    # recurring billing (ARB) system, and Freemium to just keep up-to-date on
    # transactions.
    #
    # Check whether this option is available for your gateway of choice.
    # Note that either this or fully_controlled_billing must be called for proper setup.
    def enable_arb_integration
      Subscription.send(:include, Freemium::RecurringBilling)
    end

    # How many days to keep an account active after it fails to pay.
    attr_writer :days_grace
    def days_grace
      @days_grace ||= 3
    end

    # What plan to assign to subscriptions that have expired. May be nil.
    attr_writer :expired_plan
    def expired_plan
      @expired_plan ||= SubscriptionPlan.find(:first, :conditions => "rate_cents = 0")
    end
  end
end