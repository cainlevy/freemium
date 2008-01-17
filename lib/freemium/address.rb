module Freemium
  # eventually, this should mimic ActiveMerchant's credit card object, with validation and errors, etc.
  # for now it's just a dumb (and therefore untested) data structure.
  class Address
    attr_accessor :street, :city, :state, :zip, :country, :email
    def initialize(options = {})
      options.each do |key, value|
        setter = "#{key}="
        self.send(setter, value) if self.respond_to? setter
      end
    end
  end
end