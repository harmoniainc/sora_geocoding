require 'singleton'
require 'hash_recursive_merge'

module SoraGeocoding
  class ConfigurationHash < Hash
    include HashRecursiveMerge

    def method_missing(method, *args, &block)
      key?(method) ? self[method] : super
    end

    def respond_to_missing?(method, include_private)
      key?(method) ? true : super
    end
  end

  #
  # Configuration options should be set by passing a hash:
  #
  #   SoraGeocoding.configure(
  #     :timeout     => 5,
  #     :site        => 'yahoo',
  #     :yahoo_appid => '2a9fsa983jaslfj982fjasd'
  #   )
  #
  def self.configure(options = nil)
    options ? Configuration.instance.configure(options) : config
  end

  #
  # Read-only access to the singleton's config data.
  #
  def self.config
    Configuration.instance.data
  end

  #
  # Read-only access to specific config data.
  #
  def self.config_for_lookup(lookup_name)
    data = config.clone
    data.select! { |key, _value| Configuration::OPTIONS.include?(key) }
    data.merge!(config[lookup_name]) if config.key?(lookup_name)
    data
  end

  class Configuration
    include Singleton

    OPTIONS = %i[
      timeout
      http_headers
      use_https
      http_proxy
      https_proxy
      basic_auth
      site
      yahoo_appid
      logger_level
      always_raise
    ].freeze

    attr_accessor :data

    def self.set_defaults
      instance.set_defaults
    end

    OPTIONS.each do |o|
      define_method o do
        @data[o]
      end
      define_method "#{o}=" do |value|
        @data[o] = value
      end
    end

    def configure(options)
      @data.rmerge!(options)
    end

    def initialize
      @data = SoraGeocoding::ConfigurationHash.new
      set_defaults
    end

    def set_defaults
      # options
      @data[:timeout]      = 3           # timeout (secs)
      @data[:http_headers] = {}          # HTTP headers
      @data[:use_https]    = false       # use HTTPS for requests?
      @data[:http_proxy]   = nil         # HTTP proxy server (user:pass@host:port)
      @data[:https_proxy]  = nil         # HTTPS proxy server (user:pass@host:port)
      @data[:basic_auth]   = {}          # user and password for basic auth ({:user => "user", :password => "password"})
      @data[:site]         = nil
      @data[:yahoo_appid]  = nil         # API key for Yahoo Geocoder API
      @data[:logger_level] = ::Logger::WARN # log level, if kernel logger is used

      # [supports]
      # - :all
      # - SocketError
      # - Timeout::Error
      @data[:always_raise] = []
    end

    instance_eval(OPTIONS.map do |option|
      o = option.to_s
      <<-INSTANCE_DATA
      def #{o}
        instance.data[:#{o}]
      end

      def #{o}=(value)
        instance.data[:#{o}] = value
      end
      INSTANCE_DATA
    end.join("\n\n"))
  end
end
