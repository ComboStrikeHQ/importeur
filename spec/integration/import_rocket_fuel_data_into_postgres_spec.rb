# frozen_string_literal: true

require 'rocketfuel_api'

RSpec.describe 'Import Rocketfuel data into Postgres', :vcr, :db do
  subject(:etl) do
    Importeur::ETL.new(
      extractor: Importeur::Extractor.new(
        rocketfuel_data_source,
        cursor,
        'rocketfuel-advertisers'
      ),
      transformer: transformer,
      loader: Importeur::ActiveRecordPostgresLoader.new(Affiliate, :id)
    )
  end

  let(:rocketfuel_data_source) do
    Importeur::DataSources::Rocketfuel.new(rocketfuel_service)
  end

  let(:rocketfuel_service) do
    RocketfuelApi::Service::Company.new(rocketfuel_connection)
  end

  let(:rocketfuel_connection) do
    RocketfuelApi::Connection.new(
      uri:        ENV.fetch('ROCKETFUEL_API_URI'),
      auth_token: ENV.fetch('ROCKETFUEL_API_AUTH_TOKEN'),
      logger:     Logger.new('/dev/null')
    )
  end

  let(:transformer) do
    ->(entity) { { id: entity.id, name: entity.name } }
  end

  let(:cursor) do
    instance_double(Cursor)
  end

  before do
    allow(rocketfuel_service).to receive(:get_all).and_wrap_original do |method|
      method.call('num_elements' => 1)
    end
  end

  it 'imports data' do
    expect(cursor).to receive(:read).with('rocketfuel-advertisers').and_return(1)
    expect(cursor).to receive(:write)
      .with('rocketfuel-advertisers', 'ef804f1ad6974ac5201b39effa44cb14')

    etl.call

    expect(Affiliate.first).to have_attributes(
      id: 1,
      name: 'Ad2Games DE'
    )
  end
end
