module Freemium
  module Gateways
    class Test < Base
      def transactions(options = {})
        options
      end

      def charge(*args)
        args
      end

      def cancel(*args)
        args
      end
    end
  end
end