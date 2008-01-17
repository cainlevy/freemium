module Freemium
  # adds manual billing functionality to the Subscription class
  module ManualBilling
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def run_billing
        find_billable.each do |subscription|
          Subscription.transaction do
            # attempt to bill (use gateway)
            transaction = Freemium.gateway.charge(subscription.billing_key, subscription.subscription_plan.rate)
            transaction.success? ? subscription.receive_payment!(transaction.amount) : subscription.expire_after_grace!
          end
        end

        # actually expire any subscriptions whose time has come
        expire
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