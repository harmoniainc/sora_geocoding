require 'spec_helper'
require 'mock_helper'

RSpec.describe SoraGeocoding do
  let!(:query) { Faker::Address.city }
  let!(:geocoding_mock) { MockHttpResponse::Geocoding.new }
  let!(:yahoo_mock) { MockHttpResponse::YahooGeocoder.new }
  let!(:yahoo_base_url) { 'https://map.yahooapis.jp/geocode/V1/geoCoder' }
  before { WebMock.enable! }

  describe '.search' do
    context 'when 200 status on Geocoding API' do
      let!(:expect_url) { "https://www.geocoding.jp/api/?q=#{query}" }
      before do
        WebMock.stub_request(:get, expect_url).to_return(
          body: geocoding_mock.success(query), status: 200
        )
        @exec = subject.send(:search, query)
      end

      it 'is returned "geocoding" site.' do
        expect(@exec[:site]).to eq('geocoding')
      end

      it 'is returned latitude and longitude and google_maps tags.' do
        expect(@exec[:data].to_s).to include('lat', 'lng', 'google_maps')
        expect(@exec[:data].to_s).to match(%r{<lat>(\d+)\.(\d+)</lat>})
        expect(@exec[:data].to_s).to match(%r{<lng>(\d+)\.(\d+)</lng>})
      end
    end

    context 'when 200 status on Yahoo Geocoder API' do
      let!(:yahoo_appid) { 'aaaaa' }
      let!(:options) { { site: 'yahoo', yahoo_appid: yahoo_appid } }
      let!(:expect_url) { "#{yahoo_base_url}?appid=#{yahoo_appid}&query=#{query}&results=1&detail=full&output=xml" }

      before do
        WebMock.stub_request(:get, expect_url).to_return(
          body: yahoo_mock.success(query), status: 200
        )
        @exec = subject.send(:search, query, options)
      end

      it 'is returned "yahoo" site.' do
        expect(@exec[:site]).to eq('yahoo')
      end

      it 'is returned Status and Coordinates tags.' do
        expect(@exec[:data].to_s).to include('Status', 'Coordinates')
        expect(@exec[:data].to_s).to match(%r{<Status>200</Status>})
        expect(@exec[:data].to_s).to match(%r{<Coordinates>(\d+)\.(\d+),(\d+)\.(\d+)</Coordinates>})
      end
    end
  end

  describe '.coodinates' do
    context 'when 200 status on Geocoding API' do
      let!(:expect_url) { "https://www.geocoding.jp/api/?q=#{query}" }
      before do
        WebMock.stub_request(:get, expect_url).to_return(
          body: geocoding_mock.success(query), status: 200
        )
        @exec = subject.send(:coordinates, query)
      end

      it 'is returned "geocoding" site.' do
        expect(@exec[:site]).to eq('geocoding')
      end

      it 'is returned latitude and longitude.' do
        expect(@exec[:coordinates][:lat].to_s).to eq('33.333333')
        expect(@exec[:coordinates][:lon].to_s).to eq('133.333333')
      end
    end

    context 'when 200 status on Yahoo Geocoder API' do
      let!(:yahoo_appid) { 'aaaaa' }
      let!(:options) { { site: 'yahoo', yahoo_appid: yahoo_appid } }
      let!(:expect_url) { "#{yahoo_base_url}?appid=#{yahoo_appid}&query=#{query}&results=1&detail=full&output=xml" }

      before do
        WebMock.stub_request(:get, expect_url).to_return(
          body: yahoo_mock.success(query), status: 200
        )
        @exec = subject.send(:coordinates, query, options)
      end

      it 'is returned "yahoo" site.' do
        expect(@exec[:site]).to eq('yahoo')
      end

      it 'is returned latitude and longitude.' do
        expect(@exec[:coordinates][:lat].to_s).to eq('33.33333333')
        expect(@exec[:coordinates][:lon].to_s).to eq('133.33333333')
      end
    end
  end

  describe '.geohash' do
    context 'when latitude 33.333333333 and longitude 133.3333333' do
      let!(:lat) { '33.33333333' }
      let!(:lon) { '133.33333333' }
      before do
        @exec = subject.send(:geohash, lat, lon)
      end

      it 'is returned "wvyvdh4kezeh".' do
        expect(@exec).to eq('wvyvdh4kezeh')
      end
    end
  end
end
