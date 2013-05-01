module Dhl
  module Intraship
    class Service

      def initialize(attributes = {})
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

    end
  end
end