require 'open-uri'
require 'sora_geocoding/base'

module SoraGeocoding
  #
  # generate url
  #
  class Url < Base
    attr_accessor :site

    BASE_YAHOO_URL = 'https://map.yahooapis.jp/geocode/V1/geoCoder'.freeze
    BASE_GEOCODING_URL = 'https://www.geocoding.jp/api/'.freeze

    def initialize(query)
      @yahoo_appid = configuration.yahoo_appid
      @site = configuration.site
      @query = query
    end

    def get
      switch_site
      select
    end

    private
      def select
        if @yahoo_appid.nil? || @site == 'geocoding'
          geocoding
        elsif @site.nil? || @site == 'yahoo'
          yahoo
        end
      end

      def switch_site
        if @yahoo_appid.nil? || @site == 'geocoding'
          @site = 'geocoding'
        elsif @site.nil? || @site == 'yahoo'
          @site = 'yahoo'
        else
          raise 'Please specify the correct site.'
        end
      end

      def yahoo
        params = {
          appid: @yahoo_appid,
          query: @query,
          results: '1',
          detail: 'full',
          output: 'xml'
        }
        "#{BASE_YAHOO_URL}?#{encode_uri(params)}"
      end

      def geocoding
        params = { q: @query }
        "#{BASE_GEOCODING_URL}?#{encode_uri(params)}"
      end

      def encode_uri(params)
        URI.encode_www_form(params)
      end
  end
end
