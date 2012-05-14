require 'spec_helper'

module Dhl
  module Intraship

    ERROR_DELETE_RESPONSE = <<EOS
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
   <soapenv:Body>
      <ns4:DeleteShipmentResponse xmlns:ns4="http://de.ws.intraship">
         <Version xmlns="http://dhl.de/webservice/cisbase">
            <majorRelease>1</majorRelease>
            <minorRelease>0</minorRelease>
            <build>14</build>
         </Version>
         <Status>
            <StatusCode>1050</StatusCode>
            <StatusMessage>at least on shipment could not be deleted</StatusMessage>
         </Status>
         <DeletionState>
            <ShipmentNumber>
               <ns1:shipmentNumber xmlns:ns1="http://dhl.de/webservice/cisbase">123</ns1:shipmentNumber>
            </ShipmentNumber>
            <Status>
               <StatusCode>2000</StatusCode>
               <StatusMessage>shipment not found or is deleted.</StatusMessage>
            </Status>
         </DeletionState>
      </ns4:DeleteShipmentResponse>
   </soapenv:Body>
</soapenv:Envelope>
EOS

DELETE_RESPONSE = <<EOS
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <ns4:DeleteShipmentResponse xmlns:ns4="http://de.ws.intraship">
      <Version xmlns="http://dhl.de/webservice/cisbase">
        <majorRelease>1</majorRelease>
        <minorRelease>0</minorRelease>
        <build>11</build>
      </Version>
      <status>
        <StatusCode>0</StatusCode>
        <StatusMessage>ok</StatusMessage>
      </status>
      <DeletionState>
        <StatusCode>0</StatusCode>
        <StatusMessage>ok</StatusMessage>
        <ShipmentNumber>
          <ns1:shipmentNumber xmlns:ns1="http://dhl.de/webservice/cisbase">123</ns1:shipmentNumber>
        </ShipmentNumber>
      </DeletionState>
    </ns4:DeleteShipmentResponse>
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
        savon.expects("de:DeleteShipmentDDRequest").returns( code: 200, headers: {},body: ERROR_DELETE_RESPONSE )

        expect { @api.deleteShipmentDD("123") }.should raise_error
      end

      it "should return true on successful call" do
        savon.expects("de:DeleteShipmentDDRequest").returns( code: 200, headers: {},body: DELETE_RESPONSE )

	@api.deleteShipmentDD("123").should be_true
      end
    end

  end
end
