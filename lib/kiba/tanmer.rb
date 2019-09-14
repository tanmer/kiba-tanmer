# frozen_string_literal: true

require 'kiba'
require 'kiba/tanmer/version'
require 'kiba/tanmer/blockable'
require 'kiba/tanmer/checkpoint'
require 'kiba/tanmer/registry'
require 'kiba/tanmer/parser'
require 'kiba/tanmer/job'

module Kiba
  module Tanmer
    extend Parser
  end
end
