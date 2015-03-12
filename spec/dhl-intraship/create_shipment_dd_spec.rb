require 'spec_helper'

module Dhl
  module Intraship

    CREATE_RESPONSE = <<EOS
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <ns2:CreateShipmentResponse xmlns:ns2="http://de.ws.intraship">
      <Version xmlns="http://dhl.de/webservice/cisbase">
        <majorRelease>1</majorRelease>
        <minorRelease>0</minorRelease>
        <build>11</build>
      </Version>
      <status>
        <StatusCode>0</StatusCode>
        <StatusMessage>ok</StatusMessage>
      </status>
      <CreationState>
        <StatusCode>0</StatusCode>
        <StatusMessage>ok</StatusMessage>
        <SequenceNumber>1</SequenceNumber>
        <ShipmentNumber>
          <ns1:shipmentNumber xmlns:ns1="http://dhl.de/webservice/cisbase">00340433836000191469</ns1:shipmentNumber>
        </ShipmentNumber>
        <PieceInformation>
          <PieceNumber>
            <ns1:licensePlate xmlns:ns1="http://dhl.de/webservice/cisbase">00340433836000191469</ns1:licensePlate>
          </PieceNumber>
        </PieceInformation>
        <Labelurl>http://test-intraship.dhl.com:80/cartridge.55/WSPrint?code=2DF3501616A182E9328C91C83B00509C4A611A39324EAA66</Labelurl>
      </CreationState>
    </ns2:CreateShipmentResponse>
  </soapenv:Body>
</soapenv:Envelope>
EOS


    describe API do
      before(:each) do
        savon.expects("de:CreateShipmentDDRequest").returns(code: 200, headers: {}, body: CREATE_RESPONSE)

        config  = { user: 'user', signature: 'signature', ekp: 'ekp12345', api_user: 'test', api_pwd: 'test' }
        options = { test: true }
        @api = API.new(config, options)
        @shipment = Shipment.new(shipment_date:    Date.today + 1,
                                 sender_address:   CompanyAddress.new,
                                 receiver_address: PersonAddress.new,
                                 shipment_items:   ShipmentItem.new(weight: 2.5, length: 11, width: 13, height: 3))
      end

      it "should create an API call" do
        @api.createShipmentDD(@shipment).should_not be_nil
      end

      it "should not add multipack service with only one shipment item" do
        savon.expects('de:CreateShipmentDDRequest').with do |request|
          request.soap.to_xml.should_not include('Multipack')
        end.returns(code: 200, headers: {}, body: CREATE_RESPONSE)

        @api.createShipmentDD(@shipment).should_not be_nil
      end

      it "should add multipack service" do
        @shipment.add_shipment_item(ShipmentItem.new(weight: 2.5, length: 11, width: 13, height: 3))
        savon.expects('de:CreateShipmentDDRequest').with do |request|
          request_xml = request.soap.to_xml
          request_xml.should include('<ServiceGroupDHLPaket>')
          request_xml.should include('<Multipack>True</Multipack>')
        end.returns(code: 200, headers: {}, body: CREATE_RESPONSE)
        @api.createShipmentDD(@shipment).should_not be_nil
      end

      it "should add dhl express service with higher insurance server" do
        dhl_express_service = DhlExpressService.new(DhlExpressService::DELIVERY_ON_TIME, '13:51')
        @shipment.product_code = ProductCode::DHL_DOMESTIC_EXPRESS
        @shipment.add_service(dhl_express_service)
        savon.expects('de:CreateShipmentDDRequest').with do |request|
          request_xml = request.soap.to_xml
          request_xml.should include('<ServiceGroupDateTimeOption>')
          request_xml.should include('<DeliveryOnTime>')
          request_xml.should include('13:51')
          request_xml.should include('<HigherInsurance>')
          request_xml.should include('<InsuranceAmount>2500</InsuranceAmount>')
        end.returns(code: 200, headers: {}, body: CREATE_RESPONSE)
        @api.createShipmentDD(@shipment).should_not be_nil
      end

      it "should validate service dependencies" do
        dhl_express_service = DhlExpressService.new(DhlExpressService::DELIVERY_ON_TIME, '13:51')
        @shipment.add_service(dhl_express_service)
        expect { @api.createShipmentDD(@shipment) }.to raise_error(RuntimeError, 'The DhlExpressService can only be add to DHL Domestic Express (EXP) shipments.')
      end

    end

  end
end
