require 'spec_helper'

module Dhl
  module Intraship

ERROR_MANIFEST_RESPONSE = <<EOS
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
   <soapenv:Body>
      <ns4:DoManifestResponse xmlns:ns4="http://de.ws.intraship">
         <Version xmlns="http://dhl.de/webservice/cisbase">
            <majorRelease>1</majorRelease>
            <minorRelease>0</minorRelease>
            <build>14</build>
         </Version>
         <Status>
            <StatusCode>1050</StatusCode>
            <StatusMessage>at least on shipment could not be manifested</StatusMessage>
         </Status>
         <ManifestState>
            <ShipmentNumber>
               <ns1:shipmentNumber xmlns:ns1="http://dhl.de/webservice/cisbase">123</ns1:shipmentNumber>
            </ShipmentNumber>
            <Status>
               <StatusCode>2030</StatusCode>
               <StatusMessage>shipment not printed</StatusMessage>
            </Status>
         </ManifestState>
      </ns4:DoManifestResponse>
   </soapenv:Body>
</soapenv:Envelope>
EOS

MANIFEST_RESPONSE = <<EOS
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    <soapenv:Body>
    <ns4:DoManifestResponse xmlns:ns4="http://de.ws.intraship">
    <Version xmlns="http://dhl.de/webservice/cisbase">
    <majorRelease>1</majorRelease>
            <minorRelease>0</minorRelease>
    <build>14</build>
         </Version>
    <Status>
    <StatusCode>0</StatusCode>
            <StatusMessage>ok</StatusMessage>
    </Status>
         <ManifestState>
            <ShipmentNumber>
               <ns1:shipmentNumber xmlns:ns1="http://dhl.de/webservice/cisbase">123</ns1:shipmentNumber>
            </ShipmentNumber>
            <Status>
               <StatusCode>0</StatusCode>
               <StatusMessage>ok</StatusMessage>
            </Status>
         </ManifestState>
      </ns4:DoManifestResponse>
   </soapenv:Body>
</soapenv:Envelope>
EOS

    describe API do
      before(:each) do
        config = {user: 'user', signature: 'signature', ekp: 'ekp12345'}
        options = {test: true}
        @api = API.new(config, options)
      end


      it "should raise an exception on a failed call" do
        savon.expects("de:DoManifestDDRequest").returns( code: 200, headers: {},body: ERROR_MANIFEST_RESPONSE )

        expect { @api.doManifestDD("123") }.should raise_error
      end

      it "should return true on successful call" do
        savon.expects("de:DoManifestDDRequest").returns( code: 200, headers: {},body: MANIFEST_RESPONSE )
        @api.doManifestDD("123").should be_true
      end
    end

  end
end