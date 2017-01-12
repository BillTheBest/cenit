require 'json-schema/attributes/mongoff_properties_attribute'
require 'json-schema/attributes/mongoff_required_attribute'
require 'json-schema/attributes/mongoff_type_attribute'
require 'json-schema/attributes/mongoff_ref_attribute'
require 'json-schema/attributes/formats/uint_format'

module JSON

  class Validator

    class << self
      alias_method :json_schema_key_for, :schema_key_for

      def schema_key_for(uri)
        if uri.is_a?(Hash)
          uri
        else
          json_schema_key_for(uri)
        end
      end
    end

    def load_ref_schema(parent_schema, ref)
      ref = [ref] unless ref.is_a?(Array)
      ref.each do |r|
        schema_uri =
          if r.is_a?(String)
            absolutize_ref_uri(r, parent_schema.uri)
          else
            r
          end
        return true if self.class.schema_loaded?(schema_uri)

        schema = @options[:schema_reader].read(schema_uri)
        self.class.add_schema(schema)
        build_schemas(schema)
      end
    end
  end

  class Schema

    alias_method :json_schema_init, :initialize

    def initialize(schema, uri, parent_validator=nil)
      if uri.is_a?(Hash)
        uri.define_singleton_method(:fragment) { @_fragment }
        uri.define_singleton_method(:fragment=) { |f| @_fragment = f }
      end
      if (mongoff_model = RequestStore.store[:'[cenit]mongoff_model_validator'])
        schema = mongoff_model.data_type.merge_schema(schema)
      end
      json_schema_init(schema, uri, parent_validator)
    end

    class Mongoff < JSON::Schema::Draft4
      def initialize
        super
        @attributes['properties'] = JSON::Schema::MongoffPropertiesAttribute
        @attributes['required'] = JSON::Schema::MongoffRequiredAttribute
        @attributes['type'] = JSON::Schema::MongoffTypeAttribute
        @attributes['$ref'] = JSON::Schema::MongoffRefAttribute

        @formats.merge!('uint32' => JSON::Schema::Uint32Format,
                        'uint64' => JSON::Schema::Uint64Format)

        @names = ['mongoff']
      end

      JSON::Validator.register_validator(self.new)
    end
  end
end