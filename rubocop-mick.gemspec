# frozen_string_literal: true

require_relative "lib/rubocop/mick/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-mick"
  spec.version = RuboCop::Mick::VERSION
  spec.authors = [ "Mick Zijdel" ]
  spec.email = [ "mickzijdel@live.nl" ]

  spec.summary = "Mick's personal RuboCop cops."
  spec.description = "A RuboCop extension bundling personal cops shared across Rails projects."
  spec.homepage = "https://github.com/mickzijdel/rubocop-mick"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  # Lets RuboCop 1.72+ discover the plugin from the gem name alone.
  spec.metadata["default_lint_roller_plugin"] = "RuboCop::Mick::Plugin"

  spec.files = Dir["lib/**/*", "config/**/*", "LICENSE", "README.md"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "lint_roller", "~> 1.1"
  spec.add_dependency "rubocop", ">= 1.72"
end
