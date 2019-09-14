# frozen_string_literal: true

module Kiba
  module Tanmer
    module Blockable
      class AliasProc
        def initialize(block)
          @block = block
        end

        def new(*)
          self
        end
      end

      class SourceAliasProc < AliasProc
        def each
          value = @block.call
          if value.respond_to?(:each)
            value.each { |row| yield row }
          else
            yield value
          end
        end
      end

      class DestinationAliasProc < AliasProc
        def write(row)
          @block.call(row)
        end
      end

      def self.setup(context)
        context.instance_eval do
          @source_before_blockable = method(:source)
          @destination_before_blockable = method(:destination)
          extend Blockable
        end
      end

      def source(*args, &block)
        klass = if block
                  SourceAliasProc.new(block)
                else
                  args.shift
                end
        @source_before_blockable.call(klass, *args)
      end

      def destination(*args, &block)
        klass = if block
                  DestinationAliasProc.new(block)
                else
                  args.shift
                end
        @destination_before_blockable.call(klass, *args)
      end
    end
  end
end
