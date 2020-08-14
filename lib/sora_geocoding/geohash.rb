require 'open-uri'
require 'sora_geocoding/base'

module SoraGeocoding
  #
  # generate Geohash
  # - https://ja.wikipedia.org/wiki/%E3%82%B8%E3%82%AA%E3%83%8F%E3%83%83%E3%82%B7%E3%83%A5
  #
  class Geohash < Base
    BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz'.freeze
    REFINED_RANGE = [[-90, 90], [-180, 180]].freeze

    def initialize(lat, lon)
      @lat = lat.to_s
      @lon = lon.to_s
    end

    def encode
      calc_geohash(
        convert_byte(@lat, REFINED_RANGE[0][0], REFINED_RANGE[0][1], range(@lat)),
        convert_byte(@lon, REFINED_RANGE[1][0], REFINED_RANGE[1][1], range(@lon))
      )
    end

    private
      def range(val)
        size = calc_size(val)
        range = calc_range(size)
        max_range(range)
      end

      def max_range(range)
        [range, calc_range(-6)].max
      end

      def calc_range(size)
        10**size
      end

      def calc_size(val)
        val.to_s.split('.')[-1].size * -1
      end

      def convert_byte(val, min, max, range)
        bits = []
        while (min - max).abs > range
          mid = calc_mid(min, max)
          bit = calc_bit(val, mid)

          if bit.zero?
            max = mid
          else
            min = mid
          end

          bits.push bit
        end
        bits.join
      end

      def calc_mid(min, max)
        (min + max).to_f / 2
      end

      def calc_bit(val, mid)
        val.to_f > mid ? 1 : 0
      end

      def calc_geohash(lat, lon)
        bytes = split_bits(lat, lon)
        bytes[-1] = bytes[-1].ljust(5, '0')
        bytes.map { |v| BASE32[convert_to_decimal(v), 1] }.join
      end

      def integrate_bits(odd_bit, even_bit)
        even_bit.chars.zip(odd_bit.chars).flatten.join
      end

      def split_bits(odd_bit, even_bit)
        bytes = integrate_bits(odd_bit, even_bit)
        bytes.chars.each_slice(5).map(&:join)
      end

      def convert_to_decimal(val)
        "0b#{val}".to_i(0)
      end
  end
end
