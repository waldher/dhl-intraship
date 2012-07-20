module Dhl
  module Intraship
    class BookingInformation
      attr_accessor :product_id, :pickup_date, :ready_by_time, :closing_time, :remark, :attendance, :pickup_location, :amount_of_pieces, :amount_of_pallets,
        :weight_in_kg, :count_of_shipments, :total_volume_weight, :max_length_in_cm, :max_width_in_cm, :max_height_in_cm, :account

      VALID_PRODUCT_IDS = [:TDI, :TDN, :DDI, :DDN]

      def initialize(attributes = {})
        self.product_id = :DDN
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

      def product_id=(new_product_id)
        raise "Invalid product id '#{new_product_id}'. Please use one of #{VALID_PRODUCT_IDS}" unless VALID_PRODUCT_IDS.include?(new_product_id)
        @product_id = new_product_id
      end

      def append_to_xml(xml)
        product_id = @product_id
        xml.BookingInformation do |xml|
          xml.ProductID(product_id)
          xml.Account(account)
          xml.Attendance(attendance) if attendance
          xml.PickupDate(pickup_date)
          xml.ReadyByTime(ready_by_time)
          xml.ClosingTime(closing_time)
          xml.PickupLocation(pickup_location) if pickup_location
          xml.AmountOfPieces(amount_of_pieces) if amount_of_pieces
          xml.AmountOfPallets(amount_of_pallets) if amount_of_pallets
          xml.WeightInKG(weight_in_kg) if weight_in_kg
          xml.CountOfShipments(count_of_shipments) if count_of_shipments
          xml.TotalVolumeWeight(total_volume_weight) if total_volume_weight
          xml.MaxLengthInCM(max_height_in_cm) if max_length_in_cm
          xml.MaxWidthInCM(max_width_in_cm) if max_width_in_cm
          xml.MaxHeightInCM(max_height_in_cm) if max_length_in_cm
        end
      end
    end
  end
end