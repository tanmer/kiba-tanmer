# frozen_string_literal: true

module Kiba
  module Tanmer
    module Registry
      def self.setup(context)
        context.instance_eval do
          # NOTE: this could also likely be done with some form of included/extended hook
          # and method aliasing, in a way or another.
          @source_before_registry = method(:source)
          @transform_before_registry = method(:transform)
          @destination_before_registry = method(:destination)
          @sources_mapping = {}
          @transforms_mapping = {}
          @destinations_mapping = {}
          extend Registry
        end
      end

      def register_sources(hash)
        @sources_mapping.update hash
      end

      def register_transforms(hash)
        @transforms_mapping.update hash
      end

      def register_destinations(hash)
        @destinations_mapping.update hash
      end

      def source(key, *args)
        klass = key.is_a?(Symbol) ? @sources_mapping.fetch(key) : key
        @source_before_registry.call(klass, *args)
      end

      def transform(*args, &block)
        if block
          @transform_before_registry.call(&block)
        else
          key, *remaining_args = args
          klass = key.is_a?(Symbol) ? @transforms_mapping.fetch(key) : key
          @transform_before_registry.call(klass, *remaining_args)
        end
      end

      def destination(key, *args)
        klass = key.is_a?(Symbol) ? @destinations_mapping.fetch(key) : key
        @destination_before_registry.call(klass, *args)
      end
    end
  end
end
