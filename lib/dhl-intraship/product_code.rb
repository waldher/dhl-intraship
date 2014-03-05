module Dhl
  module Intraship
    class ProductCode
      # Day definite product codes
      DHL_PACKAGE = 'EPN'
      WORLD_PACKAGE = 'BPI'
      DHL_EURO_PACKAGE = 'EPI'
      DHL_EURO_PLUS = 'EUP'
      DHL_DOMESTIC_EXPRESS = 'EXP'

      # Time definite product codes
      DOMESTIC_EXPRESS = 'DXM'
      STARTDAY_EXPRESS = 'TDK'
      DHL_EXPRESS_WORLDWIDE = 'WPX'

      VALID_PRODUCT_CODES = [DHL_PACKAGE, WORLD_PACKAGE, DHL_EURO_PACKAGE, DHL_EURO_PLUS, DHL_DOMESTIC_EXPRESS,
                             DOMESTIC_EXPRESS, STARTDAY_EXPRESS, DHL_EXPRESS_WORLDWIDE]
    end
  end
end
