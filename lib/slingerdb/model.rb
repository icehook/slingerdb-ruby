module SlingerDB
  class Model
    class << self

      def resource_path
        @resource_path
      end

      def set_resource_path(resource_path)
        @resource_path = resource_path
      end

      def resource_name
        @resource_name
      end

      def set_resource_name(resource_name)
        @resource_name = resource_name
      end

      def attributes
        @attributes ||= {}
      end

      def attributes=(attributes)
        @attributes = attributes
      end

      def has_attribute(name, type, opts = {})
        @attributes ||= {}
        @attributes[name.to_sym] = {:type => type, :opts => opts}

        define_method "#{name}=".to_sym do |arg|
          instance_exec "#{name}=".to_sym do
            @attribute_values[name.to_sym] = arg
          end
        end

        define_method name.to_sym do
          instance_exec name.to_sym do
            @attribute_values[name.to_sym]
          end
        end
      end

      def value_to_type(value, klass)
        case
          when value.nil?
            value
          when klass == String
            value.to_s
          when klass == Float
            value.to_f
          when klass == Integer
            value.to_i
          when klass == DateTime
            DateTime.parse value
          when klass == Array
            Array(value)
          when klass == Hash
            Hash(value)
          when klass == URI
            URI.parse value
          else
            value
        end
      end

      def find(conditions = {})
        request = Adapter::Request.new :get, self.resource_path, 'search' => conditions
        response = request.send
        self.resources_to_models response.parsed_body[self.resource_name]
      end

      def resources_to_models(resources)
        resources.collect{ |resource| self.new(resource) }
      end

    end

    def initialize(attribute_values = {})
      attribute_values = attribute_values.inject({}){|h,(k,v)| h[k.to_sym] = v; h}
      attribute_values.each do |k,v|
        attribute = self.class.attributes[k]
        if attribute
          attribute_values[k] = self.class.value_to_type v, attribute[:type]
        end
      end
      @attribute_values = attribute_values
    end

  end
end