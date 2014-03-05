module Dhl
  module Intraship
    class ShipmentItem

      attr_accessor :weight, :length, :height, :width
      attr_writer :package_type
      def package_type
        @package_type || 'PK'
      end

      def initialize(attributes = {})
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

      def append_to_xml(xml)
        xml.ShipmentItem do |xml|
          xml.WeightInKG(weight)
          xml.LengthInCM(length) unless length.nil?
          xml.WidthInCM(width) unless width.nil?
          xml.HeightInCM(height) unless height.nil?
          xml.PackageType(package_type)
        end
      end

    end
  end
end
