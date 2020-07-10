require 'timeout'

module SoraGeocoding
  class ConfigurationError < StandardError
  end

  class ResponseParseError < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
    end
  end

  class InvalidRequest < StandardError
  end

  class RequestDenied < StandardError
  end

  class PaymentRequiredError < StandardError
  end

  class ForbiddenError < StandardError
  end

  class NotFoundError < StandardError
  end

  class ProxyAuthenticationRequiredError < StandardError
  end

  class OverQueryLimitError < StandardError
  end

  class ServiceUnavailable < StandardError
  end

  class Timeout < ::Timeout::Error
  end

  class NetworkError < StandardError
  end
end
