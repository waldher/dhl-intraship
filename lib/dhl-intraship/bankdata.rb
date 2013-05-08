module Dhl
  module Intraship
    class Bankdata
      attr_accessor :owner, :account_number, :bank_code, :bank_name, :iban, :bic, :note

      def initialize(attributes = {})
        attributes.each do |key, value|
          setter = :"#{key.to_s}="
          if self.respond_to?(setter)
            self.send(setter, value)
          end
        end
      end

      def append_to_xml(xml)
        xml.BankData do |xml|
          xml.cis(:accountOwner, owner)
          xml.cis(:accountNumber, account_number) unless account_number.blank?
          xml.cis(:bankCode, bank_code) unless bank_code.blank?
          xml.cis(:bankName, bank_name) unless bank_name.blank?
          xml.cis(:iban, iban) unless iban.blank?
          xml.cis(:bic, bic) unless bic.blank?
          xml.cis(:note, note) unless note.blank?
        end
      end
    end
  end
end