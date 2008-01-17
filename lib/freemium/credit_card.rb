# eventually might break this dependence, but first things first.
require 'active_merchant'
module Freemium
  class CreditCard < ActiveMerchant::Billing::CreditCard; end
end