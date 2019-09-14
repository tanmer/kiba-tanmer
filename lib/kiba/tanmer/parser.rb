# frozen_string_literal: true

module Kiba
  module Tanmer
    module Parser
      def parse(*args, &block)
        Job.new.tap do |job|
          job.define(*args, &block)
        end
      end
    end
  end
end
