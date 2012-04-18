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
api = Dhl::Infraship::Api.new(config, options)
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
