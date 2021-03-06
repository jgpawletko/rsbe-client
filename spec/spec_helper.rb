require_relative '../lib/rsbe/client'
require 'rspec/its'
require 'vcr'
require 'webmock'
require 'faraday'
require 'pry'

RSpec.configure do |config|
  # protect against hitting production service
  ENV['RSBE_USER']     = nil
  ENV['RSBE_PASSWORD'] = nil
  ENV['RSBE_HOST']     = nil

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end

VCR.configure do |c|
  c.default_cassette_options = { allow_playback_repeats: true, record: :new_episodes }
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
  c.filter_sensitive_data('user')     { ENV['RSBE_USER'] }
  c.filter_sensitive_data('password') { ENV['RSBE_PASSWORD'] }
end
