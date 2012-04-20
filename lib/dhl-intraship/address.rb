module Dhl
  module Intraship
    class Address
      attr_accessor :company, :salutation, :firstname, :lastname, :street, :house_number, :street_additional,
      :zip, :city, :country_code, :email

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
        self.country_code = country_code
      end

      def append_to_xml(xml)
        xml.Company do |xml|
          if company?
            xml.cis(:Company) do |xml|
              xml.cis(:name1, company)
              if !street_additional.blank?
                xml.cis(:name2, street_additional)
              end
            end
          else
            xml.cis(:Person) do |xml|
              xml.cis(:salutation, salutation)
              xml.cis(:firstname, firstname)
              xml.cis(:lastname, lastname)
            end
            if !street_additional.blank?
              xml.cis(:Company) do |xml|
                xml.cis(:name2, street_additional)
              end
            end
          end
        end
        xml.Address do |xml|
          xml.cis(:streetName, street)
          xml.cis(:streetNumber, house_number)
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
          xml.cis(:email, self.email)
          xml.cis(:contactPerson, "#{firstname} #{lastname}")
        end
      end
    end
  end
end