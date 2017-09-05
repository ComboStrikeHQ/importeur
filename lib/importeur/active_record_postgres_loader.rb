# frozen_string_literal: true

module Importeur
  class ActiveRecordPostgresLoader
    BATCH_SIZE = 500

    def initialize(model, primary_key)
      @model = model
      @primary_key = primary_key
    end

    def call(data)
      imported_ids = []
      seen = Set.new
      data.each_slice(BATCH_SIZE) do |batch|
        batch_ids = batch.map { |attrs| attrs[primary_key] }
        imported_ids.concat(batch_ids)
        records = records_for_batch(batch_ids)
        store_batch(batch, records, seen)
      end
      delete_old_records(imported_ids)
    end

    private

    attr_reader :model, :primary_key

    def store_batch(batch, records, seen)
      batch.each do |attrs|
        next unless seen.add?(attrs[primary_key])
        store_record(attrs, records)
      end
    end

    def store_record(attrs, records)
      record = records.fetch(attrs[primary_key], model.new)
      record.assign_attributes(attrs)
      record.deleted_at = nil
      return unless record.changed?
      record.imported_at = Time.now
      record.save!
    end

    def records_for_batch(batch_ids)
      model
        .with_deleted
        .where(primary_key => batch_ids)
        .index_by(&primary_key)
    end

    def delete_old_records(imported_ids)
      # Basically `self.class.model.where.not(primary_key => imported_ids)`, but
      # more efficient in this case.
      model
        .joins(<<-SQL)
          LEFT JOIN (SELECT unnest(ARRAY[#{imported_ids.join(',')}]::int[]) AS primary_key) AS imported
                 ON imported.primary_key = #{model.table_name}.#{primary_key}
        SQL
        .where('imported.primary_key' => nil)
        .delete_all
    end
  end
end
