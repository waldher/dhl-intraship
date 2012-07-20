require 'savon/spec'

Dir[File.join(File.dirname(__FILE__), '../lib/dhl-intraship/*.rb')].each { |f| require f }

# Prevent warnings: http://stackoverflow.com/questions/5009838/httpi-tried-to-user-the-httpi-adapter-error-using-savon-soap-library
HTTPI.log = false

RSpec.configure do |config|
  config.include Savon::Spec::Macros
end