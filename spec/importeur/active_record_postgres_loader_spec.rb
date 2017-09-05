# frozen_string_literal: true

RSpec.describe Importeur::ActiveRecordPostgresLoader do
  subject(:loader) do
    described_class.new(model, :id)
  end

  class Model < FakeModel
    attr_accessor :id, :name, :imported_at, :deleted_at
  end

  let(:model) { class_double(Model, table_name: 'cake_offers') }
  let(:dataset) do
    [
      {
        id: 1,
        name: 'My Name'
      },
      {
        id: 2,
        name: 'My Other Name'
      }
    ]
  end
  let(:records) do
    [
      instance_double(Model, id: 1, name: 'My Record With An Old Name'),
      instance_double(Model, id: 2, name: 'My Other Record')
    ]
  end
  let(:now) { Time.now }

  let(:lookup_relation) { instance_double(ActiveRecord::Relation) }
  let(:deletion_relation) { instance_double(ActiveRecord::Relation) }

  before do
    allow(model).to receive(:new).and_return(instance_double(Model))
  end

  it 'only updates records that changed' do
    expect(model).to receive(:with_deleted).and_return(lookup_relation)
    expect(lookup_relation).to receive(:where).with(id: [1, 2]).and_return(records)
    expect(Time).to receive(:now).and_return(now)

    expect(records.first).to receive(:assign_attributes).with(id: 1, name: 'My Name')
    expect(records.first).to receive(:imported_at=).with(now)
    expect(records.first).to receive(:changed?).and_return(true)
    expect(records.first).to receive(:deleted_at=).with(nil)
    expect(records.first).to receive(:save!)

    expect(records.last).to receive(:assign_attributes).with(id: 2, name: 'My Other Name')
    expect(records.last).to receive(:deleted_at=).with(nil)
    expect(records.last).to receive(:changed?).and_return(false)
    expect(records.last).not_to receive(:imported_at=)
    expect(records.last).not_to receive(:save!)

    expect(model).to receive(:joins).and_return(deletion_relation)
    expect(deletion_relation)
      .to receive(:where)
      .with('imported.primary_key' => nil)
      .and_return(deletion_relation)
    expect(deletion_relation).to receive(:delete_all)

    loader.call(dataset)
  end
end
