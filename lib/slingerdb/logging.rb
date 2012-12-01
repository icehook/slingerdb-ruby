module SlingerDB
  module Logging
    def logger
      return @logger if defined?(@logger)
      @logger = default_logger
    end

    def default_logger
      logger = Logger.new(SlingerDB.config.log_file, SlingerDB.config.log_age)
      logger.level = "Logger::Severity::#{SlingerDB.config.log_level.to_s.upcase}".constantize
      logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{Time.now.iso8601(5)}] ##{Thread.current.object_id} #{severity}: #{msg}\n"
      end
      logger
    end

    def logger=(logger)
      @logger = logger
    end

    def to_pretty(arg)
      arg = arg.to_hash if arg.respond_to?(:to_hash)
      PP.pp(arg, '')
    end

  end
end