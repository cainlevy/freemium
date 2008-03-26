require 'active_merchant' # eventually might break this dependence, but first things first.

module Freemium
  # Right now, Freemium::CreditCard is simply an alias for ActiveMerchant's CreditCard. Because really, ActiveMerchant has a great CreditCard object.
  class CreditCard < ActiveMerchant::Billing::CreditCard; end
end