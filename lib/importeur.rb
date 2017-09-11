# frozen_string_literal: true

require 'importeur/version'
require 'importeur/etl'
require 'importeur/extractor'
require 'importeur/active_record_postgres_loader'
require 'importeur/data_sources/combined'
require 'importeur/data_sources/appnexus'
require 'importeur/data_sources/rocketfuel'

module Importeur
  def self.root
    Pathname.new(File.dirname(__dir__))
  end
end
