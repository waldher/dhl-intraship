require 'spec_helper'

module Dhl
  module Intraship

    describe DhlExpressService do
      it "should build object" do
        DhlExpressService.new(DhlExpressService::EXPRESS1200).should_not be_nil
      end

      it "should raise exception if invalid time given" do
        expect { DhlExpressService.new('invalid_option') }.to raise_error(RuntimeError, /No valid express service/)
      end

      it "should raise exception if invalid time given" do
        expect { DhlExpressService.new(DhlExpressService::DELIVERY_ON_TIME, '13:AD') }.to raise_error(RuntimeError, 'Invalid time format (use hh::mm).')
      end
    end

  end
end
