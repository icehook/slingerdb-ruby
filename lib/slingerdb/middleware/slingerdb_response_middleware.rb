module SlingerDB
  class SlingerDBResponseMiddleware < Faraday::Response::Middleware
    include Logging

    ClientErrorStatuses = 400...600

    def on_complete(env)
      case env[:status]
      when 401
        raise PermissionDeniedException
      when 404
        raise UnexpectedHTTPException 
      when ClientErrorStatuses
        raise UnexpectedHTTPException
      when nil
        nil
      else
        env[:slingerdb_response] = SlingerDB::Response.new env
      end
    end

  end
end
