module Dhl
  module Intraship
    class DhlPaketMultipackService < Service

      def append_to_xml(xml)
        xml.Service do |xml|
          xml.ServiceGroupDHLPaket do |xml|
            xml.Multipack 'True'
          end
        end
      end

    end
  end
end
