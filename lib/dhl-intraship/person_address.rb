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
    end
  end
end