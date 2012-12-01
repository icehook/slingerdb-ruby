module SlingerDB
  module Configuration
    extend self

    DEFAULT_OPTIONS = OpenStruct.new({
      :log_file => STDOUT,
      :log_age => 'daily',
      :log_level => :info,
      :encryption_algorithm => 'aes-128-cbc',
      :api_key => nil,
      :endpoint => 'https://slinger.icehook.com',
      :user_agent => 'slingerdb-ruby'
    })

    def self.extended(base)
      base.reset
    end

    def reset
      self.config = OpenStruct.new
      self
    end

    def config=(config)
      if config.kind_of?(IO)
        options = YAML.load(config)
      elsif config.kind_of?(String)
        options = YAML.load(File.read(config))
      elsif config.kind_of?(Hash)
        options = config
      else
        options = {}
      end

      Connection.reset!
      @options = OpenStruct.new(DEFAULT_OPTIONS.marshal_dump.merge(options))
    end

    def config
      @options
    end

  end
end