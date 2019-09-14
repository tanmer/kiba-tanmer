# frozen_string_literal: true

require 'kiba-common/dsl_extensions/show_me'
require 'kiba-common/dsl_extensions/logger'
require 'awesome_print'
require 'forwardable'

module Kiba
  module Tanmer
    class Job
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
      end

      def checkpoint(key)
        checkpoints.fetch(key)
      end

      def define(source_as_string = nil, source_file = nil, &source_as_block)
        if source_as_string
          # this somewhat weird construct allows to remove a nil source_file
          context.instance_eval(*[source_as_string, source_file].compact)
        else
          context.instance_eval(&source_as_block)
        end
        self
      end

      def run
        ::Kiba.run(control)
      end
    end
  end
end
