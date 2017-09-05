# frozen_string_literal: true

require 'bundler/setup'
require 'importeur'
require 'pry'
require 'vcr'
require 'database_cleaner'

Dir[Importeur.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |c|
  c.configure_rspec_metadata!

  c.cassette_library_dir = Importeur.root.join('spec', 'fixtures', 'vcr')
  c.hook_into :webmock

  c.default_cassette_options = { allow_unused_http_interactions: false }

  c.filter_sensitive_data('aws-access-key-id') { ENV['AWS_ACCESS_KEY_ID'] }
end
