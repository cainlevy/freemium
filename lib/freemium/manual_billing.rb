module Freemium
  # adds manual billing functionality to the Subscription class
  module ManualBilling
    def self.included(base)
      base.extend ClassMethods
    end

    # charges this subscription.
    # assumes, of course, that this module is mixed in to the Subscription model
    def charge!
      self.class.transaction do
        # attempt to bill (use gateway)
        transaction = Freemium.gateway.charge(billing_key, subscription_plan.rate)
        Freemium.activity_log[self] << transaction if Freemium.log?
        transaction.success? ? receive_payment!(transaction.amount) : expire_after_grace!
      end
    end

    module ClassMethods
      # the process you should run periodically
      def run_billing
        Freemium.with_activity_logging do
          # charge all billable subscriptions
          find_billable.each(&:charge!)
          # actually expire any subscriptions whose time has come
          expire

          # send the activity report
          Freemium.mailer.deliver_admin_report(
            Freemium.admin_report_recipients,
            Freemium.activity_log
          ) if Freemium.admin_report_recipients
        end
      end

      protected

      # a subscription is due on the last day it's paid through. so this finds all
      # subscriptions that expire the day *after* the given date. note that this
      # also finds past-due subscriptions, as long as they haven't been set to
      # expire.
      def find_billable(date = Date.today)
        find(
          :all,
          :include => :subscription_plan,
          :conditions => ['rate_cents > 0 AND paid_through <= ? AND (expire_on IS NULL or expire_on < paid_through)', date.to_date]
        )
      end
    end
  end
end