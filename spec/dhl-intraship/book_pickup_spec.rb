# encoding: utf-8

require 'spec_helper'

module Dhl
  module Intraship

ERROR_PICKUP_RESPONSE = <<EOS
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
   <soapenv:Body>
      <ns4:BookPickupResponse xmlns:ns4="http://de.ws.intraship">
         <Version xmlns="http://dhl.de/webservice/cisbase">
            <majorRelease>1</majorRelease>
            <minorRelease>0</minorRelease>
            <build>14</build>
         </Version>
         <Status>
            <StatusCode>2120</StatusCode>
            <StatusMessage>Please select a product in the shipment details. | Ordereraddress company name required | Ordereraddress ZIP required | The current ZIP format doesn´t correspond to the required format of the country of receiver. Further informations will be available in the online-help. | House number is missing at the Ordereraddress. | Ordereraddress phone required | Ordereraddress contact required | Street is missing at the Ordereraddress. | House number is missing at the Ordereraddress. | Ordereraddress city required</StatusMessage>
         </Status>
      </ns4:BookPickupResponse>
   </soapenv:Body>
</soapenv:Envelope>
EOS

PICKUP_RESPONSE = <<EOS
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
   <soapenv:Body>
      <ns2:BookPickupResponse xmlns:ns2="http://de.ws.intraship">
         <Version xmlns="http://dhl.de/webservice/cisbase">
            <majorRelease>1</majorRelease>
            <minorRelease>0</minorRelease>
            <build>11</build>
         </Version>
         <Status>
            <StatusCode>0</StatusCode>
            <StatusMessage>We have received your Individual Collection DHL Parcel under order number '123'.</StatusMessage>
         </Status>
         <ConfirmationNumber>123</ConfirmationNumber>
      </ns2:BookPickupResponse>
   </soapenv:Body>
</soapenv:Envelope>
EOS

    describe API do
      before(:each) do
        config = {user: 'user', signature: 'signature', ekp: 'ekp12345'}
        options = {test: true}
        @api = API.new(config, options)
        @booking_information = BookingInformation.new(pickup_date: Date.today, ready_by_time: '10:00', closing_time: '14:00')
      end

      it "should raise an exception on a failed call" do
        savon.expects("de:BookPickupRequest").returns( code: 200, headers: {},body: ERROR_PICKUP_RESPONSE )

        expect { @api.bookPickup(@booking_information, CompanyAddress.new) }.should raise_error
      end

    end

  end
end