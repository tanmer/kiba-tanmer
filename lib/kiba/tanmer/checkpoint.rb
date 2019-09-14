# frozen_string_literal: true

module Kiba
  module Tanmer
    module Checkpoint
      StoreCheckpoint = Class.new(Hash)

      def self.setup(context)
        context.instance_eval do
          extend Checkpoint
        end
      end

      def checkpoints
        @checkpoints ||= StoreCheckpoint.new
      end

      def checkpoint(name)
        transform { |row| checkpoints[name] = row }
      end
    end
  end
end
