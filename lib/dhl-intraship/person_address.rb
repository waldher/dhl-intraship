module Dhl
  module Intraship
    class PersonAddress < Address
      attr_accessor :salutation, :firstname, :lastname
      
      protected
      
      def company_xml(xml)
        xml.cis(:Person) do |xml|
          xml.cis(:salutation, salutation)
          xml.cis(:firstname, firstname)
          xml.cis(:lastname, lastname)
        end
      end

      def communication_xml(xml)
        if !self.street_additional.blank? && street_additional_above_street?
          xml.cis(:contactPerson, street_additional)
        else
          xml.cis(:contactPerson, "") # This line is hiding the contact person line for receivers
        end
      end
    end
  end
end