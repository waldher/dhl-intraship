require 'dhl-intraship/api'
require 'dhl-intraship/shipment'

describe Dhl::Intraship::API do
  before(:each) do
    config = {user: 'user', signature: 'signature', ekp: 'ekp12345'}
    options = {test: true}
    @api = Dhl::Intraship::API.new(config, options)
  end

  it "should create an API call" do
    shipment = Dhl::Intraship::Shipment.new

    @api.createShipmentDD([shipment]).should_not be_nil
  end

end