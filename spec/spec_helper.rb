# frozen_string_literal: true

require 'bundler/setup'
require 'recomendacao'
require 'pry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  def mp3_file(basename)
    directory = File.expand_path('../fixtures', __FILE__)
    File.join(directory, basename)
  end
end
