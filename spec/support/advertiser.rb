# frozen_string_literal: true

require 'active_record'

class Affiliate < ActiveRecord::Base
  def self.with_deleted
    self
  end
end
