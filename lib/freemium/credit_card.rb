module Freemium
  # I've vendor'd ActiveMerchant's CreditCard functionality, but I'd still like to alias it into the Freemium namespace.
  class CreditCard < ::ActiveMerchant::Billing::CreditCard; end
end