$:.push File.dirname(__FILE__)
require 'logger'
require 'tempfile'
require 'open3'
require 'date'
require 'open-uri'
require 'zlib'
require 'fileutils'
require 'home_run'
require 'base64'
require 'encryptor'
require 'ostruct'
require 'excon'
require 'oj'
require 'hashie'
require 'hirb'
require 'conformist'
require 'eventmachine'
require 'nokogiri'
require 'net/ftp'
require 'em-synchrony'
require 'em-synchrony/fiber_iterator'
require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/multi_json'
require 'active_support/core_ext/object/blank'
require 'active_support/notifications'
require 'active_support/inflector'
require 'slingerdb/version'
require 'slingerdb/utils'
require 'slingerdb/configuration'
require 'slingerdb/logging'
require 'slingerdb/connection'
require 'slingerdb/request'
require 'slingerdb/response'
require 'slingerdb/middleware/slingerdb_response_middleware'
require 'slingerdb/model'
require 'slingerdb/remote_model'
require 'slingerdb/models/upload'
require 'slingerdb/models/download'
require 'slingerdb/models/device'
require 'slingerdb/models/call_detail_record'
require 'slingerdb/models/call_detail_record_format'
require 'slingerdb/models/call_detail_record_field'
require 'slingerdb/models/report'

module SlingerDB
  extend Configuration
  extend Logging
  extend Utils

  class << self

  end

end

Faraday.register_middleware :response, :slingerdb_response => lambda { SlingerDB::SlingerDBResponseMiddleware }

ActiveSupport::Notifications.subscribe('request.faraday') do |name, start_time, end_time, _, env|
  url = env[:url]
  http_method = env[:method].to_s.upcase
  duration = end_time - start_time
  SlingerDB.logger.info '[%s] %s %s (%.3f s)' % [url.host, http_method, url.request_uri, duration]
end

