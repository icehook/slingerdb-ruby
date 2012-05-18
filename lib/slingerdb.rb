require 'logger'
require 'tempfile'
require 'open3'
require 'open-uri'
require 'fileutils'
require 'home_run'
require 'httparty'
require 'json'
require 'json/ext'
require 'base64'
require 'encryptor'
require File.join File.dirname(__FILE__), 'slingerdb', 'version'
require File.join File.dirname(__FILE__), 'slingerdb', 'adapter'
require File.join File.dirname(__FILE__), 'slingerdb', 'model'
require File.join File.dirname(__FILE__), 'slingerdb', 'models', 'upload'

module SlingerDB
  class << self

    def defaults
      {
          :log_level => Logger::INFO,
          :logger => Logger.new($stdout),
          :encryption_algroithm => 'aes-128-cbc',
          :api_key => nil,
          :slinger_uri => 'https://slinger.icehook.com'
      }
    end

    def options
      @options ||= self.defaults
    end

    def options=(options)
      @options = self.options.merge options
      @logger = self.init_logger self.options[:logger], self.options[:log_level]
      self.logger.debug "options set as: #{@options.inspect}"
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

      self.options = self.config_to_options @config
    end

    def logger
      unless @logger
        begin
          @logger = self.init_logger self.options[:logger], self.options[:log_level]
        rescue Exception => e
          @logger = Logger.new($stdout)
          @logger.level = Logger::INFO
          @logger.error e.message
          @logger.error e.backtrace.join("\n")
        end
      end

      @logger
    end

    def logger=(logger)
      @logger = logger
      @logger = self.init_logger @logger, self.options[:log_level]
    end

    def encryptor
      Encryptor
    end

    protected

      def init_logger(logger, level)
        logger.level = level
        init_logger_formatter logger
        logger
      end

      def init_logger_formatter(logger)
        original_formatter = Logger::Formatter.new
        logger.formatter = proc do |severity, datetime, progname, msg|
          original_formatter.call(severity, datetime, progname, msg.dump)
        end
      end

      def config_to_options(config)
        options = config.inject({}){|h,(k,v)| h[k.to_sym] = v; h}

        options.delete :logger

        self.logger.debug options.inspect

        if options[:log_level] && self.logger.class.constants.include?(options[:log_level].upcase.to_sym)
          options[:log_level] = self.logger.class.const_get options[:log_level].upcase
        end

        options
      end

  end
end
