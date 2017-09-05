# frozen_string_literal: true

require 'active_record'

class FakeModel
  include ActiveModel::Model

  class << self
    def table_name; end

    def where(*_); end

    def joins(*_); end

    def with_deleted; end
  end

  def save!; end

  def assign_attributes(_); end

  def changed?; end
end
