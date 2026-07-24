# frozen_string_literal: true

require 'rubocop'
require 'rubocop/rspec/support'
require 'rubocop-mick'

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense

  config.disable_monkey_patching!
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
