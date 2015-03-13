require 'savon/spec'

require "webmock/rspec"
require "dhl-intraship"

# Prevent warnings: http://stackoverflow.com/questions/5009838/httpi-tried-to-user-the-httpi-adapter-error-using-savon-soap-library
HTTPI.log = false

Savon.configure do |config|
  config.log = false
end

RSpec.configure do |config|
  config.include Savon::Spec::Macros

  config.before do
    stub_request(:get, "https://test:test@cig.dhl.de/cig-wsdls/com/dpdhl/wsdl/geschaeftskundenversand-api/1.0/geschaeftskundenversand-api-1.0.wsdl").
    to_return(:body => File.read('spec/support/geschaeftskundenversand-api-1.0.wsdl'))
  end
end
