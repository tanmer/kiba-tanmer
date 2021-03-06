# frozen_string_literal: true

require 'kiba-common/dsl_extensions/show_me'
require 'kiba-common/dsl_extensions/logger'
require 'awesome_print'
require 'forwardable'

module Kiba
  module Tanmer
    module Job
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def define_etl(source_as_string = nil, source_file = nil, &source_as_block)
          if source_as_string
            @defined_etl_block = proc { instance_eval(*[source_as_string, source_file].compact) }
          else
            @defined_etl_block = source_as_block
          end
          self
        end

        def defined_etl_block
          @defined_etl_block
        end

        def sources_mapping
          @sources_mapping ||= {}
        end

        def register_sources(hash)
          sources_mapping.update(hash)
        end

        def transforms_mapping
          @transforms_mapping ||= {}
        end

        def register_transforms(hash)
          transforms_mapping.update(hash)
        end

        def destinations_mapping
          @destinations_mapping ||= {}
        end

        def register_destinations(hash)
          destinations_mapping.update(hash)
        end
      end

      extend Forwardable

      attr_reader :context, :control
      def_delegators :context, :checkpoints, :register_sources, :register_transforms, :register_destinations

      def initialize
        @control = Kiba::Control.new
        @context = Kiba::Context.new(@control)
        # setup Tanmer extentions
        [Registry, Checkpoint, Blockable].map { |ext| ext.setup(context) }
        # add Kiba extentions
        context.send :extend, Kiba::DSLExtensions::Config
        context.config :kiba, runner: Kiba::StreamingRunner
        context.send :extend, Kiba::Common::DSLExtensions::Logger
        context.send :extend, Kiba::Common::DSLExtensions::ShowMe

        context.register_sources self.class.sources_mapping
        context.register_transforms self.class.transforms_mapping
        context.register_destinations self.class.destinations_mapping

        context.instance_eval(&self.class.defined_etl_block)
        self
      end

      def checkpoint(key)
        checkpoints.fetch(key)
      end

      def run
        ::Kiba.run(control)
      end
    end
  end
end
