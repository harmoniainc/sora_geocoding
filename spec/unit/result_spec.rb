require 'spec_helper'
require 'mock_helper'

RSpec.describe SoraGeocoding::Results do
  let!(:query) { Faker::Address.city }
  let!(:geocoding_mock) { MockHttpResponse::Geocoding.new }
  let!(:yahoo_mock) { MockHttpResponse::YahooGeocoder.new }

  describe '.coordinates' do
    context 'when result geocoding api' do
      let!(:geocoding_success) { SoraGeocoding::Results::Geocoding.new(geocoding_mock.success(query)) }
      it 'returned latlon' do
        coordinates = geocoding_success.coordinates
        expect(coordinates[:lat]).to eq('33.333333')
        expect(coordinates[:lon]).to eq('133.333333')
      end

      let!(:geocoding_error) { SoraGeocoding::Results::Geocoding.new(geocoding_mock.error) }
      it 'returned RuntimeError "Geocoding API error: Error XML"' do
        expect { geocoding_error.coordinates }.to raise_error(RuntimeError)
      end
    end

    context 'when result yahoo geocoder api' do
      let!(:yahoo_success) { SoraGeocoding::Results::YahooGeocoder.new(yahoo_mock.success(query)) }
      it 'returned latlon' do
        coordinates = yahoo_success.coordinates
        expect(coordinates[:lat]).to eq('33.33333333')
        expect(coordinates[:lon]).to eq('133.33333333')
      end

      let!(:yahoo_error) { SoraGeocoding::Results::YahooGeocoder.new(yahoo_mock.error) }
      it 'returned RuntimeError "Yahoo Geocoder API error: Error XML"' do
        expect { yahoo_error.coordinates }.to raise_error(RuntimeError)
      end

      let!(:yahoo_zero) { SoraGeocoding::Results::YahooGeocoder.new(yahoo_mock.zero_result) }
      it 'returned RuntimeError "Yahoo Geocoder API error: 001 Zero Results"' do
        expect { yahoo_zero.coordinates }.to raise_error(RuntimeError)
      end
    end
  end
end
