# frozen_string_literal: true

require 'appnexusapi'

RSpec.describe 'Import AppNexus data into Postgres', :vcr, :db do
  subject(:etl) do
    Importeur::ETL.new(
      extractor: Importeur::Extractor.new(appnexus_data_source, cursor, 'advertisers'),
      transformer: transformer,
      loader: Importeur::ActiveRecordPostgresLoader.new(Affiliate, :id)
    )
  end

  let(:appnexus_data_source) do
    Importeur::DataSources::Appnexus.new(appnexus_service)
  end

  let(:appnexus_service) do
    AppnexusApi::AdvertiserService.new(appnexus_connection)
  end

  let(:appnexus_connection) do
    AppnexusApi::Connection.new(
      'username' => ENV.fetch('APPNEXUS_USERNAME'),
      'password' => ENV.fetch('APPNEXUS_PASSWORD'),
      'uri' => 'http://api-test.appnexus.com',
      'logger' => Logger.new('/dev/null')
    )
  end

  let(:transformer) do
    ->(entity) { { id: entity.id, name: entity.name } }
  end

  let(:cursor) do
    instance_double(Cursor)
  end

  before do
    allow(appnexus_service).to receive(:get_all).and_wrap_original do |method|
      method.call('num_elements' => 1)
    end
  end

  it 'imports data' do
    expect(cursor).to receive(:read).with('advertisers').and_return(1)
    expect(cursor).to receive(:write).with('advertisers', '88e0573412c07ade17bb6e5b02635a05')

    etl.call

    expect(Affiliate.first).to have_attributes(
      id: 1,
      name: 'Some Company'
    )
  end
end
