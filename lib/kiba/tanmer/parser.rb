# frozen_string_literal: true

module Kiba
  module Tanmer
    module Parser
      def parse(*args, &block)
        Class.new.tap do |klass|
          klass.define_singleton_method :name do
            '<Anonymous Job>'
          end
          klass.send :include, Job
          klass.define_etl(*args, &block)
        end.new
      end
    end
  end
end
