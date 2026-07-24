# CLAUDE.md — rubocop-mick

A personal RuboCop extension gem (a lint_roller plugin) shipping house cops shared across Rails
projects. See [README.md](README.md) for what it is and how consumers install it.

## Layout

- `lib/rubocop/cop/mick/` — the cops (one file per cop, `module Mick`).
- `lib/rubocop/mick/plugin.rb` — the lint_roller `Plugin` (discovered via the gemspec's
  `default_lint_roller_plugin` metadata; `rules` points at `config/default.yml`).
- `config/default.yml` — each cop's default config (`Enabled: true`, `Include`, …). This is what
  makes the `plugins:` key alone activate the cops in a consuming repo.
- `spec/` — RSpec `expect_offense` specs, one per cop.

## Adding a cop

1. `lib/rubocop/cop/mick/<name>.rb` — `RuboCop::Cop::Mick::<Name> < Base`.
2. Register it in `config/default.yml`.
3. `require_relative` it from `lib/rubocop-mick.rb`.
4. Add a spec asserting real offenses via `expect_offense` / `expect_no_offenses`.

## Run / test / lint

```sh
bundle install
bundle exec rspec        # cop specs
bundle exec rubocop      # self-lint (rubocop-rails-omakase + this gem's own cops)
hk run check             # full suite CI mirrors (rubocop, rspec, debride, flay, jscpd, gitleaks, …)
```

`bin/rails` does not exist — this is a gem, not a Rails app. Tests run via `rspec`, not
`bin/rails test`.

## Dev environment

Follows the dev-hooks `dev-env-setup` standard (**DEV_ENV_VERSION = 22** in `mise.toml`): tools
pinned via mise + `mise.lock`, pre-commit checks via `hk` mirrored in CI (`.github/workflows/ci.yml`).

- Provision: `mise trust && mise install`, then `hk install`.
- The Ruby template is Rails-shaped; this repo adapts it for a gem — `bundle exec` instead of
  binstubs, audits scoped to `lib/`, and the Rails-only steps (herb, brakeman, importmap-audit,
  fasterer, database_consistency, strong_migrations) dropped.
- `.debride_whitelist` covers framework callbacks (`on_send`, `about`, `rules`, …) that RuboCop /
  lint_roller call from outside the gem, so debride doesn't report them as dead code.
- This gem is **exempt from the `rubocop-mick` house-cops wiring** the v22 standard adds to other
  Ruby repos — a gem can't `github:`-depend on itself.

## Key package versions

| Package | Version | Source |
|---------|---------|--------|
| Ruby | 4.0.2 | `.ruby-version` |
| rubocop | `>= 1.72` (dev: 1.88.2) | gemspec / `Gemfile.lock` |
| lint_roller | `~> 1.1` | gemspec |
| rspec | `~> 3.13` | Gemfile |
| rubocop-rails-omakase | latest (dev-only, self-lint) | Gemfile |

Read versions from `Gemfile.lock` / the gemspec, never from memory — they drift.
