require 'dhl-intraship/api'
require 'dhl-intraship/shipment'
require 'dhl-intraship/address'

describe Dhl::Intraship::API do
  before(:each) do
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