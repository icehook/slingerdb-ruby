require 'logger'
require 'tempfile'
require 'open3'
require 'open-uri'
require 'zlib'
require 'fileutils'
require 'home_run'
require 'httparty'
require 'json'
require 'json/ext'
require 'base64'
require 'encryptor'
require File.join File.dirname(__FILE__), 'slingerdb', 'version'
require File.join File.dirname(__FILE__), 'slingerdb', 'utils'
require File.join File.dirname(__FILE__), 'slingerdb', 'adapter'
require File.join File.dirname(__FILE__), 'slingerdb', 'model'
require File.join File.dirname(__FILE__), 'slingerdb', 'models', 'upload'

module SlingerDB
  class << self

    def defaults
      {
          :log_level => Logger::INFO,
          :logger => Logger.new($stdout),
          :encryption_algorithm => 'aes-128-cbc',
          :api_key => nil,
          :slinger_uri => 'https://slinger.icehook.com'
      }
    end

    def options
      @options ||= self.defaults
    end

    def options=(options)
      @options = self.options.merge self.sanitize_options options
      self.logger = self.init_logger(@options[:logger], @options[:log_level])
      #self.logger.debug "options set as: #{@options.inspect}"
    end

    def config
      @config
    end

    def config=(config)
      @config = if config.kind_of? Hash
        config
      elsif config.kind_of? String
        YAML.load_file config
      elsif config.kind_of? IO
        YAML.load config.read
      end

      self.options = self.sanitize_options @config
    end

    def logger
      unless @logger
        @logger = self.init_logger self.options[:logger], self.options[:log_level]
      else
        @logger
      end
    end

    def logger=(logger)
      @logger = logger
    end

    def encryptor
      Encryptor
    end

    protected

      def init_logger(logger, level)
        if level.is_a?(String)
          logger.level = self.string_to_log_level level
        else
          logger.level = level
        end

        init_logger_formatter logger

        logger
      end

      def init_logger_formatter(logger)
        original_formatter = Logger::Formatter.new
        logger.formatter = proc do |severity, datetime, progname, msg|
          original_formatter.call(severity, datetime, progname, msg.dump)
        end
      end

      def sanitize_options(options)
        options = options.inject({}){|h,(k,v)| h[k.to_sym] = v; h}

        options.delete :logger

        #self.logger.debug options.inspect

        if options[:log_level] && options[:log_level].is_a?(String)
          options[:log_level] = self.string_to_log_level options[:log_level]
        end

        options
      end

      def string_to_log_level(s)
        if s && s.is_a?(String) && Logger.constants.include?(s.upcase.to_sym)
          Logger.const_get s.upcase
        end
      end

  end
end
