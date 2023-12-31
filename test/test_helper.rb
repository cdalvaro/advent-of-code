# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter %r{^/test/}
end

require "simplecov-cobertura"
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

require "minitest/autorun"
