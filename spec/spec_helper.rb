# frozen_string_literal: true

require 'bundler/setup'
require 'importeur'
require 'pry'
require 'vcr'
require 'database_cleaner'

Dir[Importeur.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all, db: true) do
    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.establish_connection(ENV.fetch('DATABASE_URL'))
    end
  end

  config.around(:each, db: true) do |example|
    DatabaseCleaner.cleaning(&example)
  end
end

VCR.configure do |c|
  c.configure_rspec_metadata!

  c.cassette_library_dir = Importeur.root.join('spec', 'fixtures', 'vcr')
  c.hook_into :webmock

  c.default_cassette_options = { allow_unused_http_interactions: false }

  c.before_record do |i|
    i.request.headers.delete('X-Auth-Token')
    i.response.headers.delete('Set-Cookie')
    i.response.headers.delete('X-Auth-Token')
  end

  c.filter_sensitive_data('aws-access-key-id') { ENV['AWS_ACCESS_KEY_ID'] }
  c.filter_sensitive_data('appnexus-username') { ENV['APPNEXUS_USERNAME'] }
  c.filter_sensitive_data('appnexus-password') { ENV['APPNEXUS_PASSWORD'] }
end
