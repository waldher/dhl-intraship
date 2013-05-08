module Dhl
  module Intraship
    class CODService < Service
      attr_accessor :amount, :currency, :bankdata

      def append_to_xml(xml)
        xml.Service do |xml|
          xml.ServiceGroupOther do |xml|
            xml.COD do |xml|
              xml.CODAmount(amount)
              xml.CODCurrency(currency)
            end
          end
        end
        bankdata.append_to_xml(xml)
      end

    end
  end
end