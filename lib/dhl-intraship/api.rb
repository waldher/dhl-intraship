module Dhl
  module Intraship
    class API

      DEFAULT_NAMESPACES = {
          "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
          "xmlns:de" => "http://de.ws.intraship",
          "xmlns:is" => "http://dhl.de/webservice/is_base_de",
          "xmlns:cis" => "http://dhl.de/webservice/cisbase"}

      INTRASHIP_WSDL = ""
      INTRASHIP_ENDPOINT = ""
      INTRASHIP_TEST_WSDL = "http://test-intraship.dhl.com/ws/1_0/ISService/DE.wsdl"
      INTRASHIP_TEST_ENDPOINT = "http://test-intraship.dhl.com/ws/1_0/de/ISService"

       def initialize(config, options = {})
         raise "User must be specified" if config[:user].blank?
         raise "Signature (password) must be specified" if config[:signature].blank?
         raise "EKP (first part of the DHL account number) must be specified" if config[:ekp].blank?

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
         @client = Savon::Client.new do
           wsdl.document = wsdl_url
           wsdl.endpoint = endpoint
         end
       end

      def createShipmentDD(shipments)
        begin
          returnXML = @config[:label_response_type] && @config[:label_response_type] == 'XML';
          result = @client.request "de:CreateShipmentDDRequest" do
            soap.xml do |xml|
              xml.soapenv(:Envelope, DEFAULT_NAMESPACES) do |xml|
                xml.soapenv(:Header) do |xml|
                  xml.cis(:Authentification) do |xml|
                    xml.cis(:user, @user)
                    xml.cis(:signature, @signature)
                    xml.cis(:accountNumber, "#{@ekp}|#{@procedure_id}|#{@partner_id}")
                    xml.cis(:type, '0')
                  end
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
                        shipment.append_to_xml(@ekp, @partner_id, xml)
                        xml.LabelResponseType('XML') if returnXML
                        end
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
            raise "Intraship call failed with code #{r[:status][:status_code]}: #{r[:status][:status_message]}"
          end
        rescue Savon::Error => error
          raise error
        end
      end
    end
  end
end