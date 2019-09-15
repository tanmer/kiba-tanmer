# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kiba/tanmer/version'

Gem::Specification.new do |spec|
  spec.name          = 'kiba-tanmer'
  spec.version       = Kiba::Tanmer::VERSION
  spec.authors       = ['xiaohui']
  spec.email         = ['xiaohui@tanmer.com']

  spec.summary       = 'Kiba extension for Tanmer'
  spec.description   = 'Add exteions for Tanmer'
  spec.homepage      = 'https://github.com/tanmer/kiba-tanmer'
  spec.license       = 'MIT'

  # spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'awesome_print'
  spec.add_dependency 'kiba', '~> 2.5'
  spec.add_dependency 'kiba-common', '~> 0.9.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
end
