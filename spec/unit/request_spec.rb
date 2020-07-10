require 'spec_helper'
require 'mock_helper'

RSpec.describe SoraGeocoding::Request do
  let!(:query) { Faker::Address.city }
  before { WebMock.enable! }

  describe '.fetch_data' do
    let!(:geocoding_mock) { MockHttpResponse::Geocoding.new }
    let!(:yahoo_mock) { MockHttpResponse::YahooGeocoder.new }

    context 'when 200 status on Geocoding API' do
      let!(:expect_url) { "https://www.geocoding.jp/api/?q=#{query}" }

      before do
        WebMock.stub_request(:get, expect_url).to_return(
          body: geocoding_mock.success(query), status: 200
        )
      end

      it 'is returned latitude and longitude and google_maps tags.' do
        res = subject.send(:fetch_data, expect_url)
        expect(res.to_s).to include('lat', 'lng', 'google_maps')
        expect(res.to_s).to match(%r{<lat>(\d+)\.(\d+)</lat>})
        expect(res.to_s).to match(%r{<lng>(\d+)\.(\d+)</lng>})
      end
    end

    context 'when 200 status on Yahoo Geocoder API' do
      let!(:yahoo_appid) { 'aaaaa' }
      let!(:expect_url) { "https://map.yahooapis.jp/geocode/V1/geoCoder?appid=#{yahoo_appid}&query=#{query}" }

      before do
        WebMock.stub_request(:get, expect_url).to_return(
          body: yahoo_mock.success(query), status: 200
        )
      end

      it 'is returned Status and Coordinates tags.' do
        res = subject.send(:fetch_data, expect_url)
        expect(res.to_s).to include('Status', 'Coordinates')
        expect(res.to_s).to match(%r{<Status>200</Status>})
        expect(res.to_s).to match(%r{<Coordinates>(\d+)\.(\d+),(\d+)\.(\d+)</Coordinates>})
      end
    end

    context 'when response errors' do
      let!(:expect_url) { "https://www.geocoding.jp/api/?q=#{query}" }

      before { SoraGeocoding.configure({ always_raise: :all }) }

      it 'is returned InvalidRequest' do
        WebMock.stub_request(:get, expect_url).to_return(status: 400)
        expect { subject.send(:fetch_data, expect_url) }.to raise_error(SoraGeocoding::InvalidRequest)
      end

      it 'is returned RequestDenied' do
        WebMock.stub_request(:get, expect_url).to_return(status: 401)
        expect { subject.send(:fetch_data, expect_url) }.to raise_error(SoraGeocoding::RequestDenied)
      end

      it 'is returned PaymentRequiredError' do
        WebMock.stub_request(:get, expect_url).to_return(status: 402)
        expect { subject.send(:fetch_data, expect_url) }.to raise_error(SoraGeocoding::PaymentRequiredError)
      end

      it 'is returned ForbiddenError' do
        WebMock.stub_request(:get, expect_url).to_return(status: 403)
        expect { subject.send(:fetch_data, expect_url) }.to raise_error(SoraGeocoding::ForbiddenError)
      end

      it 'is returned NotFoundError' do
        WebMock.stub_request(:get, expect_url).to_return(status: 404)
        expect { subject.send(:fetch_data, expect_url) }.to raise_error(SoraGeocoding::NotFoundError)
      end

      it 'is returned ProxyAuthenticationRequiredError' do
        WebMock.stub_request(:get, expect_url).to_return(status: 407)
        expect { subject.send(:fetch_data, expect_url) }.to raise_error(SoraGeocoding::ProxyAuthenticationRequiredError)
      end

      it 'is returned OverQueryLimitError' do
        WebMock.stub_request(:get, expect_url).to_return(status: 429)
        expect { subject.send(:fetch_data, expect_url) }.to raise_error(SoraGeocoding::OverQueryLimitError)
      end

      it 'is returned ServiceUnavailable' do
        WebMock.stub_request(:get, expect_url).to_return(status: 503)
        expect { subject.send(:fetch_data, expect_url) }.to raise_error(SoraGeocoding::ServiceUnavailable)
      end
    end
  end
end
