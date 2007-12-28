module Freemium
  module Gateways
    class Base #:nodoc
      # concrete classes need to support these options:
      #   :billing_key - only retrieve transactions for this specific billing key
      #   :after:      - only retrieve transactions after this datetime (non-inclusive)
      #   :before:     - only retrieve transactions before this datetime (non-inclusive)
      #
      # return value should be a collection of Freemium::Transaction objects.
      def transactions(options = {})
        raise MethodNotImplemented
      end

      # charges money against the given billing key. only used for manual billing processes,
      # and so may not be appropriate for all concrete classes. should return a
      # Freemium::Transaction object.
      def charge(billing_key, amount)
        raise MethodNotImplemented
      end

      # cancels the subscription identified by the given billing key.
      # this might mean removing it from the remote system, or halting the remote
      # recurring billing.
      def cancel(billing_key)
        raise MethodNotImplemented
      end
    end
  end
end
