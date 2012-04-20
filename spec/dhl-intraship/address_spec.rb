require 'spec_helper'

module Dhl
  module Intraship

    describe Address do
      before{@address = Address.new}

      it "should remove the part after a + from the email address" do
        @address.email = "test+part@teameurope.net"
        @address.email.should == "test@teameurope.net"
      end

    end
  end
end