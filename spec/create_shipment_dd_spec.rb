require 'savon/spec'
require 'dhl-intraship/api'
require 'dhl-intraship/shipment'
require 'dhl-intraship/address'

RSpec.configure do |config|
  config.include Savon::Spec::Macros
end

TEST_RESPONSE = <<EOS
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

describe Dhl::Intraship::API do
  before(:each) do
    savon.expects("de:CreateShipmentDDRequest" ).returns( code: 200, headers: {},body: TEST_RESPONSE )

    config = {user: 'user', signature: 'signature', ekp: 'ekp12345'}
    options = {test: true}
    @api = Dhl::Intraship::API.new(config, options)
  end

  it "should create an API call" do
    shipment = Dhl::Intraship::Shipment.new
    shipment.shipment_date=Date.today + 1

    sender = Dhl::Intraship::Address.new
    receiver = Dhl::Intraship::Address.new
    shipment.receiver_address=receiver
    shipment.sender_address=sender

    @api.createShipmentDD([shipment]).should_not be_nil
  end

end