# depends on the Money gem
require 'money'
# and the ActiveMerchant CreditCard object (vendor'd)
Dependencies.load_paths << File.expand_path(File.join(File.dirname(__FILE__), 'vendor', 'active_merchant', 'lib'))
