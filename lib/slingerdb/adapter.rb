module SlingerDB
  module Adapter
    class Request
      attr_accessor :method

      class << self
        def get_uri(uri)
          HTTParty.get uri.to_s, :limit => 2, :parser => nil
        end

        def get_file(uri)
          tf = Utils.create_tempfile 'slingerdb_request_get_file_', '.tmp', '/tmp'
          tf.binmode
          open uri.to_s do |f|
            tf.write f.read
          end
          tf.flush
          tf.rewind
          tf
        end

        def serialize_params(params)
          Array(params).map do |key, value|
            if value.nil?
              key.to_s
            elsif value.is_a?(Array)
              value.map {|v| "#{key}=#{URI.encode(v.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"}
            else
              HTTParty::HashConversions.to_params(key => value)
            end
          end.flatten.sort.join('&')
        end
      end

      def initialize(method, path, params = {}, opts = {})
        @method = method.to_sym
        @path = path
        self.add_params params
      end

      def params
        @params ||= {
            :auth_token => SlingerDB.options[:api_key]
        }
      end

      def add_params(params)
        if params
          params.each do |k,v|
            self.add_param k, v
          end
        end
      end

      def add_param(k, v)
        @params = self.params
        @params[k] = v
      end

      def serialize_params
        self.class.serialize_params self.params
      end

      def base_uri
        @base_uri ||= URI.parse SlingerDB.options[:slinger_uri]
      end

      def path
        @path
      end

      def uri
        URI.parse "#{self.base_uri}/#{self.path}?#{self.serialize_params}"
      end

      def send
        case @method
          when :get
            Response.new self, self.get
          when :get_file
            self.get_file
          else

        end
      end

      def get
        self.class.get_uri self.uri
      end

      def get_file
        self.class.get_file self.uri
      end

    end

    class Response
      attr_reader :body, :parsed_body

      def self.parse_body(body)
        JSON.parse body
      end

      def initialize(request, party_response)
        @request = request
        @party_response = party_response
      end

      def code
        @party_response.code
      end

      def body
        @party_response.body
      end

      def parsed_body
        @parsed_body ||= self.class.parse_body self.body
      end

      def successful?
        self.code == 200
      end

      def pagination_attrs
        @pagination_attrs ||= {
            :total_count => self.parsed_body['total_count'].to_i,
            :count => self.parsed_body['count'].to_i,
            :offset => self.parsed_body['offset'].to_i,
            :current_page => self.parsed_body['current_page'].to_i,
            :per_page => self.parsed_body['per_page'].to_i
        }
      end

    end
  end
end