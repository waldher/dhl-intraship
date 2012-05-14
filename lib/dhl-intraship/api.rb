require 'savon'

module Dhl
  module Intraship
    class API

      DEFAULT_NAMESPACES = {
          "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
          "xmlns:de" => "http://de.ws.intraship",
          "xmlns:is" => "http://dhl.de/webservice/is_base_de",
          "xmlns:cis" => "http://dhl.de/webservice/cisbase"}

      INTRASHIP_WSDL = "http://www.intraship.de/ws/1_0/ISService/DE.wsdl"
      INTRASHIP_ENDPOINT = "http://www.intraship.de/ws/1_0/de/ISService"
      INTRASHIP_TEST_WSDL = "http://test-intraship.dhl.com/ws/1_0/ISService/DE.wsdl"
      INTRASHIP_TEST_ENDPOINT = "http://test-intraship.dhl.com/ws/1_0/de/ISService"

       def initialize(config, options = {})
         raise "User must be specified" if config[:user].nil?
         raise "Signature (password) must be specified" if config[:signature].nil?
         raise "EKP (first part of the DHL account number) must be specified" if config[:ekp].nil?

         if options[:test]
            wsdl_url = INTRASHIP_TEST_WSDL
            endpoint = INTRASHIP_TEST_ENDPOINT
         else
            wsdl_url = INTRASHIP_WSDL
            endpoint = INTRASHIP_ENDPOINT
         end

         @user = config[:user]
         @signature = config[:signature]
         @ekp = config[:ekp]
         @procedure_id = config[:procedure_id] || '01'
         @partner_id = config[:partner_id] || '01'

         @options = options
         @client = ::Savon::Client.new do
           wsdl.document = wsdl_url
           wsdl.endpoint = endpoint
         end
       end

      def createShipmentDD(shipments)
        begin
          shipments = [shipments] unless shipments.respond_to?('each')

          # For some reason the class instance variables are not accessible inside of the request block
	  ekp = @ekp
          partner_id = @partner_id

          returnXML = @config && @config[:label_response_type] && @config[:label_response_type] == :xml;
          result = @client.request "de:CreateShipmentDDRequest" do
            soap.xml do |xml|
              xml.soapenv(:Envelope, DEFAULT_NAMESPACES) do |xml|
                xml.soapenv(:Header) do |xml|
                  append_default_header_to_xml(xml)
                end
                xml.soapenv(:Body) do |xml|
                  xml.de(:"CreateShipmentDDRequest") do |xml|
                    xml.cis(:Version) do |xml|
                      xml.cis(:majorRelease, '1')
                      xml.cis(:minorRelease, '0')
                    end
                    xml.ShipmentOrder do |xml|
                      xml.SequenceNumber('1')
                      shipments.each do |shipment|
                        shipment.append_to_xml(ekp, partner_id, xml)
                        xml.LabelResponseType('XML') if returnXML
                      end
                    end
                  end
                end
              end
            end
          end
          r = result.to_hash[:create_shipment_response]
          if r[:status][:status_code] == '0'
            shipment_number = r[:creation_state][:shipment_number][:shipment_number]

            if returnXML
              xml_label = r[:creation_state][:xmllabel]
              {shipment_number: shipment_number, xml_label: xml_label}
            else
              label_url = r[:creation_state][:labelurl]
              {shipment_number: shipment_number, label_url: label_url}
            end

          else
            raise "Intraship call failed with code #{r[:status][:status_code]}: #{r[:status][:status_message]} (Status messages: #{r[:creation_state][:status].to_s})"
          end
        rescue Savon::Error => error
          raise error
        end
      end

      def deleteShipmentDD(shipment_number)
        begin
          result = @client.request "de:DeleteShipmentDDRequest" do
            soap.xml do |xml|
              xml.soapenv(:Envelope, DEFAULT_NAMESPACES) do |xml|
                xml.soapenv(:Header) do |xml|
                  append_default_header_to_xml(xml)
                end
                xml.soapenv(:Body) do |xml|
                  xml.de(:"DeleteShipmentDDRequest") do |xml|
                    xml.cis(:Version) do |xml|
                      xml.cis(:majorRelease, '1')
                      xml.cis(:minorRelease, '0')
                    end
                    xml.ShipmentNumber do |xml|
                      xml.cis(:shipmentNumber, shipment_number)
                    end
                  end
                end
              end
	    end
          end
          r = result.to_hash[:delete_shipment_response]

	  # Return true if successful
          raise "Intraship call failed with code #{r[:status][:status_code]}: #{r[:status][:status_message]} (Status messages: #{r[:deletion_state][:status].to_s})" unless r[:status][:status_code] == '0'

	  true
	rescue Savon::Error => error
          raise error
        end
      end

protected
      def append_default_header_to_xml(xml)
          # For some reason the class instance variables are not accessible inside of the request block
          user = @user
          signature = @signature
          ekp = @ekp
          procedure_id = @procedure_id
          partner_id = @partner_id

          xml.cis(:Authentification) do |xml|
            xml.cis(:user, user)
            xml.cis(:signature, signature)
            xml.cis(:accountNumber, "#{ekp}|#{procedure_id}|#{partner_id}")
            xml.cis(:type, '0')
          end
      end
    end
  end
end
