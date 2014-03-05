module Dhl
  module Intraship
    class DhlExpressService < Service

      # Bundles following services for domestic time-definite products
      # offered by DHL Express. One of the services must be chosen, if
      # this service bundle is invoked

      DELIVERY_ON_TIME   = 'DeliveryOnTime'
      DELIVERY_EARLY     = 'DeliveryEarly'
      EXPRESS0900        = 'Express0900'
      EXPRESS1000        = 'Express1000'
      EXPRESS1200        = 'Express1200'
      DELIVERY_AFTERNOON = 'DeliveryAfternoon'
      DELIVERY_EVENING   = 'DeliveryEvening'
      EXPRESS_SATURDAY   = 'ExpressSaturday'
      EXPRESS_SUNDAY     = 'Expresssunday'

      VALID_EXPRESS_SERVICES = [DELIVERY_ON_TIME, DELIVERY_EARLY, EXPRESS0900, EXPRESS1000, EXPRESS1200,
                                DELIVERY_AFTERNOON, DELIVERY_EVENING, EXPRESS_SATURDAY, EXPRESS_SUNDAY]


      def initialize(service, time = nil)
        @service, @time = service, time
        unless VALID_EXPRESS_SERVICES.include?(@service)
          raise "No valid express service #{@service}"
        end

        if @service == DELIVERY_ON_TIME
          raise "Time is missing while DeliveryOnTime is specified." if time.blank?
          raise "Invalid time format (use hh::mm)." if time !~ /^\d\d:\d\d$/
        end
      end

      def append_to_xml(xml)
        xml.Service do |xml|
          xml.ServiceGroupDateTimeOption do |xml|
            xml.tag! @service, @time || 'True'
          end
        end
      end

    end
  end
end
