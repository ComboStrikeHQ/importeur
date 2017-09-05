# frozen_string_literal: true

require 'importeur/version'
require 'importeur/etl'
require 'importeur/extractor'
require 'importeur/active_record_postgres_loader'

module Importeur
  def self.root
    Pathname.new(File.dirname(__dir__))
  end
end
