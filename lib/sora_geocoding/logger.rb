require 'logger'
require 'singleton'

module SoraGeocoding
  def self.log(level, message)
    Logger.instance.log(level, message)
  end

  #
  # Logger
  #
  class Logger
    include Singleton

    LOG_LEVEL = {
      debug: ::Logger::DEBUG,
      info: ::Logger::INFO,
      warn: ::Logger::WARN,
      error: ::Logger::ERROR,
      fatal: ::Logger::FATAL
    }.freeze

    def log(level, message)
      raise StandardError, 'SoraGeocoding tried to log a message with an invalid log level.' unless valid_level?(level)

      if respond_to?(:add)
        add(LOG_LEVEL[level], message)
      else
        raise SoraGeocoding::ConfigurationError, 'Please specify valid logger for SoraGeocoding. ' \
                                                 'Logger specified must respond to `add(level, message)`.'
      end
      nil
    end

    def add(level, message)
      return unless log_message_at_level?(level)

      case level
      when ::Logger::DEBUG, ::Logger::INFO
        puts message
      when ::Logger::WARN
        warn message
      when ::Logger::ERROR
        raise message
      when ::Logger::FATAL
        raise message
      end
    end

    private
      def valid_level?(level)
        LOG_LEVEL.keys.include?(level)
      end

      def log_message_at_level?(level)
        level >= SoraGeocoding.config.logger_level
      end
  end
end
