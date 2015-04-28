# encoding: UTF-8

require 'spec_helper'

module Dhl
  module Intraship

    CREATE_REQUEST  = File.read('spec/support/create_shipment_dd_request.xml')
    CREATE_RESPONSE = File.read('spec/support/create_shipment_dd_response.xml')

    describe API do
      subject { @api.createShipmentDD(@shipment) }

      before(:each) do
        savon.expects("de:CreateShipmentDDRequest").returns(code: 200, headers: {}, body: CREATE_RESPONSE)
        config  = { user: 'user', signature: 'signature', ekp: 'ekp12345', api_user: 'test', api_pwd: 'test' }
        options = { test: true }
        @api = API.new(config, options)
        @shipment = Shipment.new({
          shipment_date:  Date.parse('2015-03-13'),

          sender_address: CompanyAddress.new({
            company: 'Team Europe Ventures',
            contact_person: 'John Smith',
            street: 'Mohrenstraße',
            house_number: '60',
            zip: '10117',
            city: 'Berlin',
            country_code: 'DE',
            email: 'info@teameurope.net',
          }),

          receiver_address: PersonAddress.new({
            firstname: 'John',
            lastname: 'Doe',
            street: 'Mainstreet',
            house_number: '10',
            street_additional: 'Appartment 2a',
            zip: '90210',
            city: 'Springfield',
            country_code: 'DE',
            email: 'john.doe@example.com',
          }),

          shipment_items:   ShipmentItem.new(weight: 2.5, length: 11, width: 13, height: 3)
        })
      end

      it "should create an API call" do
        savon.expects('de:CreateShipmentDDRequest').with do |request|
          request.soap.to_xml.should == CREATE_REQUEST.gsub(/>\s+/,'>')
        end.returns(code: 200, headers: {}, body: CREATE_RESPONSE)

        should_not be_nil
      end

      it "should not add multipack service with only one shipment item" do
        savon.expects('de:CreateShipmentDDRequest').with do |request|
          request.soap.to_xml.should_not include('Multipack')
        end.returns(code: 200, headers: {}, body: CREATE_RESPONSE)

        should_not be_nil
      end

      it "should add multipack service" do
        @shipment.add_shipment_item(ShipmentItem.new(weight: 2.5, length: 11, width: 13, height: 3))
        savon.expects('de:CreateShipmentDDRequest').with do |request|
          request_xml = request.soap.to_xml
          request_xml.should include('<ServiceGroupDHLPaket>')
          request_xml.should include('<Multipack>True</Multipack>')
        end.returns(code: 200, headers: {}, body: CREATE_RESPONSE)

        should_not be_nil
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

        should_not be_nil
      end

      it "should validate service dependencies" do
        dhl_express_service = DhlExpressService.new(DhlExpressService::DELIVERY_ON_TIME, '13:51')
        @shipment.add_service(dhl_express_service)

        expect { subject }.to raise_error(RuntimeError, 'The DhlExpressService can only be add to DHL Domestic Express (EXP) shipments.')
      end

    end

  end
end
