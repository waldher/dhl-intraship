module Dhl
  module Intraship
    class CompanyAddress < Address
      attr_accessor :company, :contact_person

      protected
      
      def company_xml(xml)
        xml.cis(:Company) do |xml|
          xml.cis(:name1, company)
          xml.cis(:name2, street_additional) if !street_additional.blank? && street_additional_above_street?
        end
      end
      
      def communication_xml(xml)
        xml.cis(:contactPerson, contact_person)
      end
    end
  end
end