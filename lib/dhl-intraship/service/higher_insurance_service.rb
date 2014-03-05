module Dhl
  module Intraship
    class HigherInsuranceService < Service

      def initialize(amount = 2500, currency = 'EUR')
        @amount, @currency = amount, currency

        unless [2500, 25000].include?(@amount)
          raise 'The insurance amount have to be 2500 or 25000!'
        end
      end

      def append_to_xml(xml)
        xml.Service do |xml|
          xml.ServiceGroupOther do |xml|
            xml.HigherInsurance do |xml|
              xml.InsuranceAmount(@amount)
              xml.InsuranceCurrency(@currency)
            end
          end
        end
      end

    end
  end
end
