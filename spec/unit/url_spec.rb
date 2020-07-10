require 'spec_helper'

RSpec.describe SoraGeocoding::Url do
  context '.get' do
    let!(:query) { Faker::Address.city }
    subject { SoraGeocoding::Url.new(query) }

    context 'when generating Yahoo Geocoder API URL' do
      let!(:yahoo_appid) { 'aaaaa' }
      let!(:base_url) { 'https://map.yahooapis.jp/geocode/V1/geoCoder' }

      before do
        SoraGeocoding.configure({ site: 'yahoo', yahoo_appid: yahoo_appid })
      end

      it 'is generated correctly' do
        verify_url = subject.get
        expect_url = Regexp.escape("#{base_url}?appid=#{yahoo_appid}&query=#{query.gsub(/[[:space:]]/, '+')}")
        expect(verify_url).to match(/#{expect_url}/)
      end
    end

    context 'when the option is not specified' do
      let!(:base_url) { 'https://www.geocoding.jp/api/' }

      before do
        SoraGeocoding.configure({ site: 'yahoo', yahoo_appid: nil })
      end

      it 'is generated correctly Geocoding API URL' do
        verify_url = subject.get
        expect_url = Regexp.escape("#{base_url}?q=#{query.gsub(/[[:space:]]/, '+')}")
        expect(verify_url).to match(/#{expect_url}/)
      end
    end

    context 'when generating Geocoding API URL' do
      let!(:base_url) { 'https://www.geocoding.jp/api/' }

      before do
        SoraGeocoding.configure({ site: 'geocoding' })
      end

      it 'is generated correctly' do
        verify_url = subject.get
        expect_url = Regexp.escape("#{base_url}?q=#{query.gsub(/[[:space:]]/, '+')}")
        expect(verify_url).to match(/#{expect_url}/)
      end
    end
  end
end
