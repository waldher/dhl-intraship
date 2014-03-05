require 'savon/spec'

require "dhl-intraship"

# Prevent warnings: http://stackoverflow.com/questions/5009838/httpi-tried-to-user-the-httpi-adapter-error-using-savon-soap-library
HTTPI.log = false

RSpec.configure do |config|
  config.include Savon::Spec::Macros
end
