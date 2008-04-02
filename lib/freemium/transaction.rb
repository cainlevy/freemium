module Freemium
  # a temporary model to describe a transaction
  class Transaction
    # the id of the client in the remote system
    attr_accessor :billing_key
    # the amount of the transaction in Money
    attr_accessor :amount
    # if the transaction was a success or not (default is false)
    attr_accessor :success

    def initialize(options = {})
      options.each do |(k, v)|
        setter = "#{k}="
        self.send(setter, v) if respond_to? setter
      end
    end

    alias_method :success?, :success

    def to_s
      "#{success? ? "billed" : "failed to bill"} key #{billing_key} for #{amount.format}"
    end
  end
end