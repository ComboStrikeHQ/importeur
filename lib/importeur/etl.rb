module Importeur
  class ETL
    def initialize(extractor:, transformer:, loader:)
      @extractor = extractor
      @transformer = transformer
      @loader = loader
    end

    def call
      extracted = extractor.call
      return if extracted.nil?
      transformed = extracted.lazy.flat_map do |entity|
        transformer.call(entity)
      end
      loader.call(transformed.lazy)
    end

    private

    attr_reader :extractor, :transformer, :loader
  end
end
