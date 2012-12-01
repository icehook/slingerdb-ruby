module SlingerDB
  module Request
    include Connection
    extend self

    def build_path(parts = [], ext = '.json')
      "#{File.join(parts.compact.map!{ |p| p.to_s })}#{ext}"
    end

    def get(path, params={}, options={}, &callback)
      request(:get, path, params, options, &callback)
    end

    def delete(path, params={}, options={}, &callback)
      request(:delete, path, params, options, &callback)
    end

    def post(path, params={}, options={}, &callback)
      request(:post, path, params, options, &callback)
    end

    def put(path, params={}, options={}, &callback)
      request(:put, path, params, options, &callback)
    end

    def request(method, path, params, options, &callback)
      conn = options[:connection] || self.connection
      resp = conn.send(method) { |request|
        config_request(method, path, params, options, request)
      }
    end

    private

    def config_request(method, path, params, options, request)
      case method.to_sym
      when :delete, :get
        request.url(path, params)
      when :post, :put
        request.path = path
        request.body = params unless params.empty?
      end
    end

  end
end