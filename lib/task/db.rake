# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.test')

require 'active_record'

desc 'Create a database for testing'
task :create_test_db do
  database_configuration =
    ActiveRecord::ConnectionAdapters::ConnectionSpecification::ConnectionUrlResolver.new(
      ENV.fetch('DATABASE_URL')
    ).to_hash

  ActiveRecord::Tasks::DatabaseTasks.drop(database_configuration)
  ActiveRecord::Tasks::DatabaseTasks.create(database_configuration)

  ActiveRecord::Base.establish_connection(ENV.fetch('DATABASE_URL'))
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Schema.define(version: 1) do
    drop_table :affiliates if table_exists?(:affiliates)
    create_table :affiliates do |t|
      t.string :name
      t.datetime :deleted_at
      t.datetime :imported_at
    end
  end
end
