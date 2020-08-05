require 'timeout'

module SoraGeocoding
  class Base
    #
    # Symbol which is used in configuration to refer to this Lookup.
    #
    def handle
      str = self.class.to_s
      str[str.rindex(':') + 1..-1].gsub(/([a-z\d]+)([A-Z])/, '\1_\2').downcase.to_sym
    end

    #
    # specific config data
    #
    def configuration
      SoraGeocoding.config_for_lookup(handle)
    end

    #
    # Raise exception.
    # Return false if exception not raised.
    #
    def raise_error(error, message = nil)
      exceptions = configuration.always_raise
      raise error, message if (exceptions == :all) || exceptions.include?(error.is_a?(Class) ? error : error.class)

      false
    end
  end
end
