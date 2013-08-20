module SlingerDB
  class RemoteModel < Model
    include Connection
    include Request

    DEFAULT_RESOURCE_ATTRIBUTES = {
      :path_base => nil,
      :path_ext => '.json',
      :index_method => nil,
      :collection_name => '',
      :per_page => 25
    }

    @resource_attributes = DEFAULT_RESOURCE_ATTRIBUTES

    def destroy!(params = {}, options = {})
      path = Request.build_path [self.class.path_base, self.id.to_s], self.class.path_ext

      Request.delete(path, params, options)
    end

    class << self
      attr_accessor :resource_attributes

      def path_ext;resource_attributes[:path_ext];end
      def index_method;resource_attributes[:index_method];end
      def collection_name;resource_attributes[:collection_name];end

      def set_resource_attributes(ra)
        @resource_attributes = DEFAULT_RESOURCE_ATTRIBUTES.merge(ra)
      end

      def path_base(params = {})
        pb = @resource_attributes[:path_base] || File.join('/', collection_name)
        params.each { |k,v| pb.gsub!(":#{k}", v) } unless params.blank?
        pb
      end

      def all(conditions = {}, options = {})
        path = Request.build_path [path_base, index_method], path_ext
        paging = {}
        paging[:per_page] = options[:per_page] || resource_attributes[:per_page]
        paging[:page] = options[:page] if options[:page]
        params = conditions.merge(paging)
        models = []

        resp = Request.get path, params, options
        first_resp = slingerdb_response(resp)
        models += response_models(first_resp)

        if first_resp.has_next_page?
          cp = first_resp.current_page
          total_pages_left = first_resp.total_pages - cp
          pages_left = (options[:max_pages] || total_pages_left)
          responses = []

          pages_left.times do |i|
            page = cp + i + 1
            responses << Request.get(path, params.merge(:page => page), options)
          end

          responses.each { |response| models += response_models response }
        end

        models
      end

      def where(conditions = {}, options = {})

      end

      def find(id, options = {})
        path = Request.build_path [path_base, id], path_ext
        object_name = collection_name.singularize
        params = {}
        model = nil

        response = Request.get(path, params, options)
        model = new(response.body) if response.status <= 200 && !response.body.blank?

        model
      end

      def create!(attributes = {}, options = {})
        path = Request.build_path [path_base], path_ext
        object_name = collection_name.singularize
        params = { object_name => attributes }
        model = nil

        response = Request.post(path, params, options)
        model = response_model response

        model
      end

      def slingerdb_response(response)
        if response.is_a?(SlingerDB::Response)
          response
        elsif response.is_a?(Faraday::Response)
          response.env[:slingerdb_response]
        end
      end

      def response_models(response)
        slingerdb_response(response).to_remote_models(collection_name, self)
      end

      def response_model(response)
        object_name = collection_name.singularize
        slingerdb_response(response).to_remote_model(object_name, self)
      end

    end

    def initialize(attributes = {})
      super
    end

  end
end