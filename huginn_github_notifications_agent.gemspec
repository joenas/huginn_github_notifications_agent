# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'huginn_github_notifications_agent'
  spec.version       = '0.0.2'
  spec.authors       = ['joenas']
  spec.email         = ['jon@jonnev.se']

  spec.summary       = 'Huginn agent to fetch Github notifications'
  # spec.description   = %q{Write a longer description or delete this line.}

  spec.homepage      = 'https://github.com/joenas/huginn_github_notifications_agent'

  spec.license       = 'MIT'

  spec.files         = Dir['LICENSE.txt', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb'].reject { |f| f[%r{^spec/huginn}] }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 0.80.1'

  spec.add_runtime_dependency 'huginn_agent'
  spec.add_runtime_dependency 'virtus', '~> 1.0'
end
