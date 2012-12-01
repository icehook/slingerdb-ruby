module SlingerDB
  class Response
    include Logging
    attr_accessor :env
    attr_accessor :request_params

    def initialize(env, request_params = {})
      @env = env
      @request_params = request_params
    end

    def body
      @env[:body]
    end

    def status
      @env[:status]
    end

    def metadata
      return @metadata if defined?(@metadata)

      if status == 200 && self.body.kind_of?(Hash)
        @metadata = {}

        self.class.metadata_keys.each { |k| @metadata[k] = self.body[k] }

        @metadata
      end
    end

    def pages_left
      if self.metadata && self.metadata[:current_page] && self.total_pages
        self.total_pages - self.metadata[:current_page]
      else
        0
      end
    end

    def total_pages
      tc, pp = self.metadata[:total_count], self.metadata[:per_page]
      ((tc % pp) > 0) ? ((tc / pp) + 1) : (tc / pp)
    end

    def current_page
      self.metadata[:current_page] if self.metadata
    end

    def has_next_page?
      self.metadata ? (self.metadata[:current_page] < self.total_pages) : false
    end

    def request_method
      @env[:method]
    end

    def to_remote_models(collection_name, klass, &blk)
      models = []

      if body && body.has_key?(collection_name.to_sym)
        body[collection_name.to_sym].each do |h|
          next if h.blank?
          m = klass.send :new, h
          models << m
          blk.call(m) if blk
        end
      end

      models
    end

    def to_remote_model(object_name, klass)
      if body && body.has_key?(object_name.to_sym)
        klass.send :new, body[object_name.to_sym]
      end
    end

    module ClassMethods
      def metadata_keys
        [
         :total_count,
         :count,
         :current_page,
         :per_page,
         :offset
        ]
      end
    end

    extend ClassMethods

  end
end