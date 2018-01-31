# frozen_string_literal: true

module Importeur
  class Extractor
    def initialize(data_source, cursor, cursor_key)
      @data_source = data_source
      @cursor = cursor
      @cursor_key = cursor_key
    end

    def call
      return unless has_new_data?
      Enumerator.new do |y|
        feed.each do |item|
          y << item
        end
        store_new_dataset_id
        clear_current_dataset_id
      end
    end

    private

    attr_reader :cursor, :cursor_key, :data_source

    def has_new_data?
      last_known_id = cursor.read(cursor_key)
      current_dataset_id != last_known_id
    end

    def store_new_dataset_id
      cursor.write(cursor_key, current_dataset_id)
    end

    def clear_current_dataset_id
      @current_dataset_id = nil
    end

    def current_dataset_id
      @current_dataset_id ||= dataset_id
    end

    def dataset_id
      data_source.dataset_unique_id
    end

    def feed
      @feed ||= data_source.items
    end
  end
end
