module SlingerDB
  class Model < OpenStruct
    include Logging
    include Utils

    @parents, @children, @only_children = [], [], []

    class << self
      attr_accessor :parents
      attr_accessor :children
      attr_accessor :only_children

      def belongs_to(*args)
        @parents = args.collect do |arg|
          "SlingerDB::#{arg.to_s.classify}".constantize
        end
      end

      def has_many(*args)
        @children = args.collect do |arg|
          "SlingerDB::#{arg.to_s.classify}".constantize
        end
      end

      def has_one(*args)
        @only_children = args.collect do |arg|
          "SlingerDB::#{arg.to_s.classify}".constantize
        end
      end
    end

    def initialize(attributes = {})
      super
      create_parent_accessors
      create_child_accessors
      create_only_child_accessors
    end

    def to_hash
      table
    end

    def to_json
      to_hash.to_json
    end

    def to_pretty_json
      MultiJson.dump(to_hash, :pretty => true)
    end

    protected

      def create_only_child_accessors
        return if self.class.only_children.blank?

        p = self.class.to_s.demodulize.underscore.singularize.to_sym

        self.class.only_children.each do |klass|
          c = klass.to_s.demodulize.underscore.singularize.to_sym

          (class << self; self; end).class_eval do
            define_method(c) do
              attributes = to_hash[c]
              logger.info attributes.inspect
              model = klass.send :new, attributes.merge({p => self}) unless attributes.blank?
            end
          end
        end
      end

      def create_child_accessors
        return if self.class.children.blank?

        p = self.class.to_s.demodulize.underscore.singularize.to_sym

        self.class.children.each do |klass|
          c = klass.to_s.demodulize.underscore.pluralize.to_sym

          (class << self; self; end).class_eval do
            define_method(c) do
              collection = to_hash[c] || []
              collection.collect do |h|
                v = h[c.to_s.singularize]
                model = klass.send :new, v.merge({p => self}) if v
              end
            end
          end
        end
      end

      def create_parent_accessors
        return if self.class.parents.blank?

        self.class.parents.each do |klass|
          p = klass.to_s.demodulize.underscore.singularize.to_sym

          (class << self; self; end).class_eval do
            define_method(p) do
              if v = to_hash[p]
                model = klass.send :new, v
              elsif id = to_hash["#{p.to_s}_id".to_sym]
                model = klass.send :find, id
              end
            end
          end
        end
      end
  end
end