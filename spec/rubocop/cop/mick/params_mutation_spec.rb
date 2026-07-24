# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::Mick::ParamsMutation, :config do
  it 'flags index assignment on params' do
    expect_offense(<<~RUBY)
      params[:title] = "x"
      ^^^^^^^^^^^^^^^^^^^^ Do not mutate `params`; build a separate hash instead.
    RUBY
  end

  it 'flags a bang mutator on params' do
    expect_offense(<<~RUBY)
      params.merge!(defaults)
      ^^^^^^^^^^^^^^^^^^^^^^^ Do not mutate `params`; build a separate hash instead.
    RUBY
  end

  it 'flags delete on params' do
    expect_offense(<<~RUBY)
      params.delete(:preferences)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not mutate `params`; build a separate hash instead.
    RUBY
  end

  it 'flags safe-navigation mutators' do
    expect_offense(<<~RUBY)
      params&.delete(:maybe)
      ^^^^^^^^^^^^^^^^^^^^^^ Do not mutate `params`; build a separate hash instead.
    RUBY
  end

  it 'does not flag reads' do
    expect_no_offenses('value = params[:q]')
  end

  it 'does not flag non-bang copy methods' do
    expect_no_offenses('attrs = params.except(:q).merge(x: 1)')
  end

  it 'does not flag mutation of a hash you own' do
    expect_no_offenses(<<~RUBY)
      attrs = params.permit(:a).to_h
      attrs[:a] = attrs[:a].strip
      attrs.delete(:b)
    RUBY
  end

  it 'does not flag mutation through an alias (documented blind spot)' do
    expect_no_offenses(<<~RUBY)
      mine = params
      mine.delete(:q)
    RUBY
  end
end
