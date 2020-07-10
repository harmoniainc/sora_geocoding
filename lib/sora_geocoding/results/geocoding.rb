require 'sora_geocoding/results/base'

module SoraGeocoding
  module Results
    #
    # get the latitude and longitude of the Geocoding API
    #
    class Geocoding < Base
      def coordinates
        check_data_for_errors!

        common = '/result/coordinate'
        lat = @data.elements["#{common}/lat"].get_text
        lon = @data.elements["#{common}/lng"].get_text
        { lat: lat, lon: lon }
      end

      def check_data_for_errors!
        error = @data.elements['/result/error']
        return unless error

        code = error.get_text.to_s
        SoraGeocoding.log(:error, "Geocoding API error: #{code} Zero Results")
      end
    end
  end
end
