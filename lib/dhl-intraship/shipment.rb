require "dhl-intraship/product_code"

module Dhl
  module Intraship
    class Shipment
      PACKAGE_TYPE = 'PK'

      attr_accessor :sender_address, :receiver_address, :shipment_date, :weight, :length, :height, :width, :product_code,
                    :customer_reference, :services

      def initialize(attributes = {})
        self.product_code = ProductCode::DHL_PACKAGE
        self.services = []
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

      def add_service(newservice)
        @services << newservice
      end

      def product_code=(product_code)
        raise "No valid product code #{product_code}" unless ProductCode::VALID_PRODUCT_CODES.include?(product_code)
        @product_code = product_code
      end

      def append_to_xml(ekp, partner_id, xml)
        raise "Shipment date must be set!" if shipment_date.nil?
        raise "Sender address must be set!" if sender_address.nil?
        raise "Receiver address must be set!" if sender_address.nil?
        xml.Shipment do |xml|
          xml.ShipmentDetails do |xml|
            xml.ProductCode(product_code)
            xml.ShipmentDate(shipment_date.strftime("%Y-%m-%d"))
            xml.cis(:EKP, ekp)
            xml.Attendance do |xml|
              xml.cis(:partnerID, partner_id)
            end
            xml.CustomerReference(customer_reference) unless customer_reference.blank?
            xml.ShipmentItem do |xml|
              xml.WeightInKG(weight)
              xml.LengthInCM(length) unless length.nil?
              xml.WidthInCM(width) unless width.nil?
              xml.HeightInCM(height) unless height.nil?
              xml.PackageType(PACKAGE_TYPE)
            end
            services.each do |service|
              service.append_to_xml(xml)
            end
          end
          # Shipper information
          xml.Shipper do |xml|
            sender_address.append_to_xml(xml)
          end
          # Receiver information
          xml.Receiver do |xml|
            receiver_address.append_to_xml(xml)
          end
        end
      end
    end
  end
end
