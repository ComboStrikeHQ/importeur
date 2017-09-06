# frozen_string_literal: true

module Importeur
  class CombinedBucketCakeFeeds
    def initialize(*entity_classes)
      @entity_classes = entity_classes
    end

    def dataset_unique_id
      data_sources.map(&:dataset_unique_id).join
    end

    def items
      Enumerator.new do |y|
        data_sources.each do |data_source|
          data_source.items.each do |entity|
            y << entity
          end
        end
      end
    end

    private

    attr_reader :entity_classes

    def data_sources
      @data_sources ||= entity_classes.map(&:new)
    end
  end
end
