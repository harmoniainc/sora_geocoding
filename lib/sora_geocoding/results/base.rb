require 'rexml/document'

module SoraGeocoding
  module Results
    #
    # The Foundation for Returning Results
    #
    class Base
      attr_accessor :data

      def initialize(data)
        @data = REXML::Document.new(data)
      end

      def coordinates
        { lat: @data['lat'], lon: @data['lon'] }
      end

      def latitude
        coordinates[:lat]
      end

      def longitude
        coordinates[:lon]
      end
    end
  end
end
