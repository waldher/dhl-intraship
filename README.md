# Dhl::Intraship

This is a simple gem to wrap the DHL Intraship SOAP Api. Note that currently only the simplest usecase is implemented:
Sending a national day definite package without any extra services.

## Installation

Add this line to your application's Gemfile:

    gem 'dhl-intraship'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dhl-intraship

## Usage

Initialize a new API object using

```ruby
api = Dhl::Infraship::API.new(config, options)
```

Config is the following hash:

```ruby
config = {user: 'your Intraship API user name', #mandatory
          signature: 'Your Intraship API user password', #mandatory
          ekp: 'Your DHL EKP (first part of your DHL Account number)', #mandatory
          procedure_id: 'The prodedureId (second part of your DHL Account number)', #optional, defaults to '01'
          partner_id: 'The partnerId (=attendance, third part of your DHL Account number)' #optional, defaults to '01'
          }
```

Options is an optional parameter and can contain the following parameters:

```ruby
options = {test: true, # If test is set, all API calls go against the Intraship test system
           label_response_type: xml, # If it's set to XML the createShipment-Calls return the label data as XML instead of the PDF-Link }
```

To send a shipment to DHL you need to create it first:

```ruby
sender_address = Dhl::Intraship::Address.new(company: 'Team Europe Ventures',
                                             street: 'Mohrenstraße',
                                             house_number: '60',
                                             zip: '10117',
                                             city: 'Berlin',
                                             country_code: 'DE',
                                             email: 'info@teameurope.net')

receiver_address = Dhl::Intraship::Address.new(firstname: 'John',
                                               lastname: 'Doe',
                                               street: 'Mainstreet',
                                               house_number: '10',
                                               street_additional: 'Appartment 2a',
                                               zip: '90210',
                                               city: 'Springfield',
                                               country_code: 'DE',
                                               email: 'john.doe@example.com')

# Note that the weight parameter is in kg and the length/height/width in cm
shipment = Dhl::Intraship::Shipment.new(sender_address: sender_address,
                                        receiver_address: receiver_address,
                                        shipment_date: Date.today,
                                        weight: 2,
                                        length: 30,
                                        height:15,
                                        width: 25)
```

Note that the actual api-call takes an array of shipments

```ruby
result = api.createShipmentDD([shipment])
```

The result contains the "shipment_number", as well as the "label_url" (or the "xml_label" when it was specified as repsonse type)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
