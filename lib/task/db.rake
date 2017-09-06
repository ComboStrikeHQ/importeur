# frozen_string_literal: true

require 'pg'

desc 'Create a database for testing'
task :create_test_db do
  conn = PG.connect(dbname: 'postgres')
  conn.exec('CREATE DATABASE importeur_test')
end
