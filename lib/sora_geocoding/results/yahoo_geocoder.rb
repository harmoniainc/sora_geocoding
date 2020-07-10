require 'sora_geocoding/results/base'

module SoraGeocoding
  module Results
    #
    # get the latitude and longitude of the Yahoo! Geocoder API
    #
    class YahooGeocoder < Base
      def coordinates
        check_data_for_errors!
        lonlat = @data.elements['/YDF/Feature/Geometry/Coordinates'].get_text.to_s.split(',')
        { lat: lonlat[1], lon: lonlat[0] }
      end

      def check_data_for_errors!
        if @data.elements['/Error']
          message = @data.elements['/Error/Message'].get_text.to_s
          code = @data.elements['/Error/Code'].get_text.to_s
          SoraGeocoding.log(:error, "Yahoo Geocoder API error: #{code} #{message}")
        elsif @data.elements['/YDF'].attributes['totalResultsReturned'].to_i < 1
          SoraGeocoding.log(:error, 'Yahoo Geocoder API error: 001 Zero Results')
        end
      end
    end
  end
end
