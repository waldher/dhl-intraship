module Dhl
  module Intraship
    class PackstationAddress < CompanyAddress
      attr_accessor :packstation, :postnumber

      def append_to_xml(xml)
        xml.Company do |xml|
          company_xml(xml)
        end
        # this element has no namespace
        xml.Packstation do |xml|
          xml.PackstationNumber packstation
          xml.PostNumber postnumber
          xml.Zip zip
          xml.City city
        end
        xml.Communication do |xml|
          xml.cis(:phone, phone) unless phone.blank?
          xml.cis(:email, email) unless email.blank?
          xml.cis(:contactPerson, contact_person.blank? ? "" : contact_person)
        end
      end
    end
  end
end