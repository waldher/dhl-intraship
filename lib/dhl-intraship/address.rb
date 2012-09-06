module Dhl
  module Intraship
    class Address
      attr_accessor :street, :house_number, :street_additional,
      :zip, :city, :country_code, :contact_person, :email, :phone

      def initialize(attributes = {})
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

      def company?
        !self.company.blank?
      end
      
      def country_code=(country_code)
        raise "Country code must be an ISO-3166 two digit code" unless country_code.length == 2
        @country_code = country_code
      end

      def append_to_xml(xml)
        xml.Company do |xml|
          company_xml(xml)
        end
        xml.Address do |xml|
          xml.cis(:streetName, street)
          xml.cis(:streetNumber, house_number)
          xml.cis(:careOfName, street_additional) unless street_additional.blank?
          xml.cis(:Zip) do |xml|
            if country_code == 'DE'
              xml.cis(:germany, zip)
            elsif ['GB','UK'].include?(country_code)
              xml.cis(:england, zip)
            else
              xml.cis(:other, zip)
            end
          end
          xml.cis(:city, city)
          xml.cis(:Origin) do |xml|
            xml.cis(:countryISOCode, country_code)
          end
        end
        xml.Communication do |xml|
          xml.cis(:phone, self.phone) unless self.phone.blank?
          xml.cis(:email, self.email) unless self.email.blank?
          xml.cis(:contactPerson, contact_person.blank? ? "" : contact_person)
        end
      end
      
      protected
      
      def company_xml(xml)
        raise "Use one of the two subclasses: PersonAddress or CompanyAddress!"
      end
      
      def communication_xml(xml)
        raise "Use one of the two subclasses: PersonAddress or CompanyAddress!"
      end
    end
  end
end