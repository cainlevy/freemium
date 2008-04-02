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

    # You need to specify whether Freemium or your gateway's ARB module will control
    # the billing process. If your gateway's ARB controls the billing process, then
    # Freemium will simply try and keep up-to-date on transactions.
    def billing_controller=(val)
      case val
        when :freemium: Subscription.send(:include, Freemium::ManualBilling)
        when :arb:      Subscription.send(:include, Freemium::RecurringBilling)
        else raise "unknown billing_controller: #{val}"
      end
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

    # If you want to receive reports whenever the run_billing process executes, supply an email (or list of emails) here
    attr_accessor :admin_report_recipients
  end
end

require File.join(File.dirname(__FILE__), 'activity_logger')