require 'spec_helper'

RSpec.describe SoraGeocoding do
  let!(:options) do
    {
      timeout: 3,
      http_headers: {},
      use_https: false,
      http_proxy: nil,
      https_proxy: nil,
      basic_auth: {},
      site: nil,
      yahoo_appid: nil,
      logger_level: ::Logger::WARN,
      always_raise: []
    }
  end

  describe '.configure' do
    describe 'when options equal nil' do
      it 'is returned defalut options' do
        expect(subject.configure(nil)).to eq(options)
      end
    end

    describe 'when site option "yahoo"' do
      it 'is returned adding site option "yahoo"' do
        options[:site] = 'yahoo'
        expect(subject.configure({ site: 'yahoo' })).to eq(options)
      end
    end
  end

  describe '.config' do
    before { subject.configure(options) }
    it 'is returned defalut options' do
      expect(subject.config).to eq(options)
    end
  end

  describe '.config_for_lookup' do
    before { subject.configure(options) }
    describe 'when lookup_name "site"' do
      it 'is returned defalut options' do
        expect(subject.config_for_lookup('site')).to eq(options)
      end
    end
  end

  describe '.new' do
    it 'is returned NoMethodError' do
      expect { SoraGeocoding::Configuration.new }.to raise_error(NoMethodError)
    end
  end
end
