# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop-ci'

RSpec::Core::RakeTask.new(:spec)

load 'lib/task/db.rake'

task default: :spec
