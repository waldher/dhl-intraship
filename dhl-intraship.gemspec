# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dhl-intraship/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexander Kops"]
  gem.email         = ["a.kops@teameurope.net"]
  gem.description   = %q{A simple gem to access the DHL Intraship API}
  gem.summary       = %q{This wraps the DHL Intraship SOAP Interface for creating shipments}
  gem.homepage      = "https://github.com/teameurope/dhl-intraship"

  gem.add_dependency "savon", "~> 0.9.9"
  gem.add_development_dependency "rspec", "~> 2.9"
  gem.add_development_dependency "savon_spec", "~> 0.1.6"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dhl-intraship"
  gem.require_paths = ["lib"]
  gem.version       = Dhl::Intraship::VERSION
end
