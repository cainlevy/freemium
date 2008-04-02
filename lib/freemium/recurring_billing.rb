module Freemium
  # adds recurring billing functionality to the Subscription class
  module RecurringBilling
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # the process you should run periodically
      def run_billing
        Freemium.with_activity_logging do
          # first, synchronize transactions
          process_new_transactions
          # then, set expiration for any subscriptions that didn't process
          find_expirable.each(&:expire_after_grace!)
          # then, actually expire any subscriptions whose time has come
          expire

          # send the activity report
          Freemium.mailer.deliver_admin_report(
            Freemium.admin_report_recipients,
            Freemium.activity_log
          ) if Freemium.admin_report_recipients
        end
      end

      protected

      # retrieves all transactions posted after the last known transaction
      #
      # please note how this works: it calculates the maximum last_transaction_at
      # value and only retrieves transactions after that. so be careful that you
      # don't accidentally update the last_transaction_at field for some subset
      # of subscriptions, and leave the others behind!
      def new_transactions
        Freemium.gateway.transactions(:after => self.maximum(:last_transaction_at))
      end

      # updates all subscriptions with any new transactions
      def process_new_transactions
        transaction do
          new_transactions.each do |t|
            subscription = Subscription.find_by_billing_key(t.billing_key)
            Freemium.activity_log[subscription] << t if Freemium.log?
            t.success? ? subscription.receive_payment!(t.amount) : subscription.expire_after_grace!
          end
        end
      end

      # finds all subscriptions that should have paid but didn't and need to be expired
      def find_expirable
        find(
          :all,
          :include => :subscription_plan,
          :conditions => ['rate_cents > 0 AND paid_through < ? AND (expire_on IS NULL OR expire_on < paid_through)', Date.today]
        )
      end
    end
  end
end