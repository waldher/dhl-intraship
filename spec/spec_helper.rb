require 'savon/spec'
require 'dhl-intraship/api'
require 'dhl-intraship/shipment'
require 'dhl-intraship/address'
require 'dhl-intraship/person_address'
require 'dhl-intraship/company_address'

RSpec.configure do |config|
  config.include Savon::Spec::Macros
end