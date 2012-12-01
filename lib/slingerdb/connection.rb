module SlingerDB
  module Connection
    extend self

    def connection(reset = false)
      if @connection && !reset
        @connection
      else
        @connection = Faraday.new(SlingerDB.config.endpoint) do |faraday|
          setup_faraday(faraday)
          faraday.adapter :em_http
        end
      end
    end

    def setup_faraday(faraday)
      faraday.headers['User-Agent'] = SlingerDB.config.user_agent

      faraday.request :multipart
      #faraday.request :url_encoded
      #faraday.request :retry
      faraday.request :oauth2, SlingerDB.config.api_key, :param_name => 'auth_token'
      faraday.request :json

      faraday.response :logger, SlingerDB.logger
      faraday.response :raise_error
      faraday.response :xml,  :content_type => /\bxml$/
      faraday.response :multi_json, symbolize_keys: true, :adapter => :oj, :content_type => /\bjson$/
      faraday.response :rashify
      faraday.response :dates
      faraday.response :slingerdb_response
      faraday.use :instrumentation
    end

    def reset!
      @connection = nil
    end

  end
end