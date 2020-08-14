require 'spec_helper'
require 'mock_helper'

RSpec.describe SoraGeocoding::Geohash do
  let!(:query) { Faker::Address.city }
  let!(:geocoding_mock) { MockHttpResponse::Geocoding.new }
  let!(:yahoo_mock) { MockHttpResponse::YahooGeocoder.new }

  describe '.encode' do
    context 'when latitude 33.333333333 and longitude 133.3333333' do
      let!(:lat) { '33.33333333' }
      let!(:lon) { '133.33333333' }
      let!(:geohash) { SoraGeocoding::Geohash.new(lat, lon) }
      it 'is returned "wvyvdh4kezeh".' do
        expect(geohash.encode).to eq('wvyvdh4kezeh')
      end
    end
  end
end
