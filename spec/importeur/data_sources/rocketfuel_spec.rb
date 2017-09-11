# frozen_string_literal: true

require 'rocketfuel_api'

RSpec.describe Importeur::DataSources::Rocketfuel do
  subject(:data_source) { described_class.new(rocketfuel_service) }

  let(:rocketfuel_service) { instance_double(RocketfuelApi::AdvertiserService) }
  let(:resource_resource)  { instance_double(RocketfuelApi::Resource) }

  before do
    expect(rocketfuel_service).to receive(:get_all).and_return([resource_resource])
  end

  describe '#items' do
    it 'returns items' do
      expect(data_source.items).to eq([resource_resource])
    end
  end

  describe '#dataset_unique_id' do
    it 'returns a hash' do
      expect(data_source.dataset_unique_id).to eq('7f112e7b6410e0257d44f0da280ee284')
    end
  end
end
