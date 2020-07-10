require 'sora_geocoding/version'
require 'sora_geocoding/configuration'
require 'sora_geocoding/logger'
require 'sora_geocoding/exceptions'
require 'sora_geocoding/base'
require 'sora_geocoding/query'
require 'sora_geocoding/url'
require 'sora_geocoding/request'
require 'sora_geocoding/results/geocoding'
require 'sora_geocoding/results/yahoo_geocoder'

#
# This library takes into account the number of API calls and address lookup to get the latitude and longitude.
# The API uses the Geocoding API and the Yahoo! Geocoder API.
#
module SoraGeocoding
  #
  # Search for information about an address or a set of coordinates.
  #
  def self.search(query, options = {})
    query = SoraGeocoding::Query.new(query, options) unless query.is_a?(SoraGeocoding::Query)
    query.nil? ? nil : query.execute
  end

  #
  # Look up the coordinates of the given street or IP address.
  #
  def self.coordinates(address, options = {})
    results = search(address, options)
    return if results.nil?

    { site: results[:site], coordinates: site_specific_coordinates(results[:site], results[:data]) }
  end

  class << self
    private
      def site_specific_coordinates(site, data)
        SoraGeocoding::Results.const_get(site_map[site]).new(data).coordinates
      end

      def site_map
        {
          'yahoo' => 'YahooGeocoder',
          'geocoding' => 'Geocoding'
        }
      end
  end
end
