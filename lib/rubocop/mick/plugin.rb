# frozen_string_literal: true

require "pathname"
require "lint_roller"

module RuboCop
  module Mick
    # lint_roller plugin entry point. RuboCop finds this class via the gemspec's
    # `default_lint_roller_plugin` metadata and activates it when a project lists
    # `rubocop-mick` under the `plugins:` key in its .rubocop.yml.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: "rubocop-mick",
          version: VERSION,
          homepage: "https://github.com/mickzijdel/rubocop-mick",
          description: "Mick's personal RuboCop cops, shared across Rails projects."
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: Pathname.new(__dir__).join("../../../config/default.yml")
        )
      end
    end
  end
end
