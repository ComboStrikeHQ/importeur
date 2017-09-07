# frozen_string_literal: true

require 'bucket_cake'

RSpec.describe 'Import BucketCake data into Postgres', :vcr, :db do
  subject(:etl) do
    Importeur::ETL.new(
      extractor: Importeur::Extractor.new(
        BucketCake::Entities::Affiliates.new,
        cursor,
        'affiliates'
      ),
      transformer: transformer,
      loader: Importeur::ActiveRecordPostgresLoader.new(Affiliate, :id)
    )
  end

  let(:transformer) do
    ->(entity) { { id: entity.id, name: entity.name } }
  end

  let(:cursor) do
    instance_double(Cursor)
  end

  it 'imports data' do
    expect(cursor).to receive(:read).with('affiliates').and_return(1)
    expect(cursor).to receive(:write).with('affiliates', '"de4835a3b685606a0324b0b091eab9e9"')

    etl.call

    expect(Affiliate.first).to have_attributes(
      id: 16202,
      name: 'gocake affiliate'
    )
  end

  it 'does not import anything if there is no new data' do
    expect(cursor).to receive(:read).with('affiliates')
      .and_return('"de4835a3b685606a0324b0b091eab9e9"')

    expect { etl.call }.not_to change(Affiliate, :count)
  end

  context 'with existing data' do
    let!(:affiliate) { Affiliate.create(id: 16202, name: 'old name') }

    it 'updates data that changed' do
      expect(cursor).to receive(:read).with('affiliates').and_return(1)
      expect(cursor).to receive(:write).with('affiliates', '"de4835a3b685606a0324b0b091eab9e9"')

      expect { etl.call }.not_to change(Affiliate, :count)

      expect(Affiliate.first).to have_attributes(
        id: 16202,
        name: 'gocake affiliate'
      )
    end
  end
end
