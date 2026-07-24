# frozen_string_literal: true

module RuboCop
  module Cop
    module Mick
      # Flags in-place mutation of the request `params` object. `params` is
      # shared request state, not a scratchpad: mutating it corrupts the data
      # every later line — and any variable aliased to it — relies on. Build a
      # separate hash (or use the non-bang, copy-returning methods) instead.
      #
      # This is a heuristic: it flags a mutating call whose *immediate* receiver
      # is a bare `params` send. It cannot follow aliases (`p = params; p.delete`)
      # — that needs flow analysis a static cop does not do.
      #
      # @example
      #   # bad
      #   params[:q] = normalize(params[:q])
      #   params.delete(:preferences)
      #   params.merge!(defaults)
      #
      #   # good
      #   query = normalize(params[:q])
      #   attrs = params.except(:preferences).merge(defaults) # non-bang: copies
      #
      class ParamsMutation < Base
        MSG = "Do not mutate `params`; build a separate hash instead."

        # Bang / in-place mutators reachable on ActionController::Parameters
        # (it quacks like a Hash). `[]=` is index assignment.
        MUTATING_METHODS = %i[
          []= delete delete_if merge! update store deep_merge!
          except! extract! slice! compact! reject! select! keep_if clear
          transform_keys! transform_values! deep_transform_keys! deep_transform_values!
        ].freeze

        # A bare `params` call — the controller helper — with no receiver.
        def_node_matcher :bare_params?, "(send nil? :params)"

        def on_send(node)
          return unless MUTATING_METHODS.include?(node.method_name)
          return unless bare_params?(node.receiver)

          add_offense(node)
        end
        alias on_csend on_send
      end
    end
  end
end
