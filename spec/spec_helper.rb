require 'savon/spec'
require 'dhl-intraship/api'
require 'dhl-intraship/shipment'
require 'dhl-intraship/address'

RSpec.configure do |config|
  config.include Savon::Spec::Macros
end