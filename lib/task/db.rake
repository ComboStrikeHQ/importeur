# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.test')

require 'pg'
require 'active_record'

desc 'Create a database for testing'
task :create_test_db do
  uri = URI.parse(ENV.fetch('DATABASE_URL'))
  conn = PG.connect(
    host: uri.hostname,
    port: uri.port,
    dbname: 'postgres',
    user: uri.user,
    password: uri.password
  )
  conn.exec('DROP DATABASE IF EXISTS importeur_test')
  conn.exec('CREATE DATABASE importeur_test')

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
