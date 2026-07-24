# rubocop-mick

A [RuboCop](https://rubocop.org) extension bundling personal cops I want on every
Rails project. Packaged as a gem so a single source of truth is shared across
repos — update once, `bundle update rubocop-mick` everywhere.

## Installation

Point at the GitHub repo (no rubygems.org publish required). In your `Gemfile`:

```ruby
gem "rubocop-mick", github: "mickzijdel/rubocop-mick", require: false
```

Then `bundle install`.

## Usage

Enable it via the RuboCop plugin API (RuboCop 1.72+). In your `.rubocop.yml`:

```yml
plugins:
  - rubocop-mick

inherit_gem:
  rubocop-mick: config/default.yml
```

On older RuboCop, use `require: rubocop-mick` instead of the `plugins:` key. Run
`bundle exec rubocop` as usual — the cops below are now active.

### `Mick/ParamsMutation`

Flags in-place mutation of the request `params` object. `params` is shared
request state, not a scratchpad — mutating it corrupts the data every later line
(and any aliased variable) relies on. Build a separate hash instead.

Avoid:

```ruby
params[:q] = normalize(params[:q])
params.delete(:preferences)
params.merge!(defaults)
```

Prefer:

```ruby
query = normalize(params[:q])
attrs = params.except(:preferences).merge(defaults) # non-bang: returns copies
```

Defaults to `Include: app/controllers/**/*.rb`.

**Heuristic, not a proof.** It flags a mutating call whose *immediate* receiver
is a bare `params`. It cannot follow aliases (`p = params; p.delete`) — that
needs flow analysis a static cop does not do. Treat it as a high-signal
tripwire.

## Development

```sh
bundle install
bundle exec rspec        # cop specs (expect_offense)
bundle exec rubocop      # self-lint
```

Each cop needs a spec that asserts on real offenses via `expect_offense`. To add
one: drop the cop under `lib/rubocop/cop/mick/`, register it in `config/default.yml`,
require it from `lib/rubocop-mick.rb`, and add a spec.

## License

MIT — see [LICENSE](LICENSE).
