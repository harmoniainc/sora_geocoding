require 'net/http'
require 'net/https'
require 'open-uri'
require 'rexml/document'

module SoraGeocoding
  class Request < Base
    def parse_xml(data)
      REXML::Document.new(data)
    rescue StandardError
      unless raise_error(ResponseParseError.new(data))
        SoraGeocoding.log(:warn, "API's response was not valid XML")
        SoraGeocoding.log(:debug, "Raw response: #{data}")
      end
    end

    def parse_raw_data(raw_data)
      parse_xml(raw_data)
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def check_response_for_errors!(response)
      if response.code.to_i == 400
        raise_error(SoraGeocoding::InvalidRequest) ||
          SoraGeocoding.log(:warn, 'API error: 400 Bad Request')
      elsif response.code.to_i == 401
        raise_error(SoraGeocoding::RequestDenied) ||
          SoraGeocoding.log(:warn, 'API error: 401 Unauthorized')
      elsif response.code.to_i == 402
        raise_error(SoraGeocoding::PaymentRequiredError) ||
          SoraGeocoding.log(:warn, 'API error: 402 Payment Required')
      elsif response.code.to_i == 403
        raise_error(SoraGeocoding::ForbiddenError) ||
          SoraGeocoding.log(:warn, 'API error: 403 Forbidden')
      elsif response.code.to_i == 404
        raise_error(SoraGeocoding::NotFoundError) ||
          SoraGeocoding.log(:warn, 'API error: 404 Not Found')
      elsif response.code.to_i == 407
        raise_error(SoraGeocoding::ProxyAuthenticationRequiredError) ||
          SoraGeocoding.log(:warn, 'API error: 407 Proxy Authentication Required')
      elsif response.code.to_i == 429
        raise_error(SoraGeocoding::OverQueryLimitError) ||
          SoraGeocoding.log(:warn, 'API error: 429 Too Many Requests')
      elsif response.code.to_i == 503
        raise_error(SoraGeocoding::ServiceUnavailable) ||
          SoraGeocoding.log(:warn, 'API error: 503 Service Unavailable')
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def fetch_data(query)
      parse_raw_data(fetch_raw_data(query))
    rescue SocketError => e
      raise_error(e) || SoraGeocoding.log(:warn, 'API connection cannot be established.')
    rescue Errno::ECONNREFUSED => e
      raise_error(e) || SoraGeocoding.log(:warn, 'API connection refused.')
    rescue SoraGeocoding::NetworkError => e
      raise_error(e) || SoraGeocoding.log(:warn, 'API connection is either unreacheable or reset by the peer')
    rescue SoraGeocoding::Timeout => e
      raise_error(e) || SoraGeocoding.log(:warn, 'API not responding fast enough ' \
        '(use SoraGeocoding.configure(:timeout => ...) to set limit).')
    end

    #
    # Make an HTTP(S) request to return the response object.
    #
    # rubocop:disable Metrics/AbcSize
    def make_api_request(query_url)
      uri = URI.parse(query_url)
      SoraGeocoding.log(:debug, "HTTP request being made for #{uri}")
      http_client.start(
        uri.host,
        uri.port,
        use_ssl: use_ssl?(uri.port),
        open_timeout: configuration.timeout,
        read_timeout: configuration.timeout
      ) do |client|
        configure_ssl!(client) if use_ssl?
        req = Net::HTTP::Get.new(uri.request_uri, configuration.http_headers)
        if configuration.basic_auth[:user] && configuration.basic_auth[:password]
          req.basic_auth(configuration.basic_auth[:user], configuration.basic_auth[:password])
        end
        client.request(req)
      end
    rescue Timeout::Error
      raise SoraGeocoding::Timeout
    rescue Errno::EHOSTUNREACH, Errno::ETIMEDOUT, Errno::ENETUNREACH, Errno::ECONNRESET
      raise SoraGeocoding::NetworkError
    end
    # rubocop:enable Metrics/AbcSize

    #
    # Detect if you are using ssl
    #
    def use_ssl?(http_port = nil)
      if (http_port == 443) || (supported_protocols == [:https])
        true
      elsif supported_protocols == [:http]
        false
      else
        configuration.use_https
      end
    end

    def configure_ssl!(client); end

    #
    # Generate a string of http, https or protocol.
    #
    def protocol
      'http' + (use_ssl? ? 's' : '')
    end

    #
    # Make HTTP requests.
    #
    def http_client
      proxy = configuration.send("#{protocol}_proxy")
      if proxy
        proxy_url = proxy =~ /^#{protocol}/ ? proxy : protocol + '://' + proxy
        begin
          uri = URI.parse(proxy_url)
        rescue URI::InvalidURIError
          raise ConfigurationError, "Error parsing #{protocol.upcase} proxy URL: '#{proxy_url}'"
        end
        Net::HTTP::Proxy(uri.host, uri.port, uri.user, uri.password)
      else
        Net::HTTP
      end
    end

    #
    # Supported Protocols
    #
    def supported_protocols
      %i[http https]
    end

    private
      def fetch_raw_data(query)
        response = make_api_request(query)
        check_response_for_errors!(response)
        response.body
      end
  end
end
