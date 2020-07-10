lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sora_geocoding/version'

Gem::Specification.new do |spec|
  spec.name          = 'sora_geocoding'
  spec.version       = SoraGeocoding::VERSION
  spec.authors       = ['hirontan']
  spec.email         = ['hirontan@sora.flights']

  spec.summary       = 'Get the latitude and longitude from the Geocoding API and the Yahoo! Geocoder API.'
  spec.description   = 'This library takes into account the number of API calls and address
                        lookup to get the latitude and longitude.
                        The API uses the Geocoding API and the Yahoo! Geocoder API.'
  spec.homepage      = 'https://rubygems.org/gems/sora_geocoding'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/hirontan/sora_geocoding'
  spec.metadata['changelog_uri'] = 'https://github.com/hirontan/sora_geocoding/blob/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
