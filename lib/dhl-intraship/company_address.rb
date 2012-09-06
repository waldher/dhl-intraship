module Dhl
  module Intraship
    class CompanyAddress < Address
      attr_accessor :company

      protected
      
      def company_xml(xml)
        xml.cis(:Company) do |xml|
          xml.cis(:name1, company)
        end
      end
    end
  end
end