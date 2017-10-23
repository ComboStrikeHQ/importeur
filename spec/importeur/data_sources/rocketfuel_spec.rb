# frozen_string_literal: true

require 'rocketfuel_api'

RSpec.describe Importeur::DataSources::Rocketfuel do
  subject(:data_source) { described_class.new(rocketfuel_service) }

  let(:rocketfuel_service) { instance_double(RocketfuelApi::Service::Company) }
  let(:resource_resource)  { instance_double(RocketfuelApi::Resource::Company) }

  before do
    allow(rocketfuel_service).to receive(:get_all).and_return([resource_resource])
  end

  describe '#items' do
    it 'returns items' do
      expect(data_source.items).to eq([resource_resource])
      expect(rocketfuel_service).to have_received(:get_all).with({})
    end
  end

  describe '#dataset_unique_id' do
    it 'returns a hash' do
      expect(data_source.dataset_unique_id).to eq('a321d32f28c72c4723523a586f0424d6')
    end
  end

  context 'with params' do
    subject(:data_source) { described_class.new(rocketfuel_service, params) }

    let(:params) { { 'filter' => 'value' } }

    it 'pass params to #get_all and returns items' do
      expect(data_source.items).to eq([resource_resource])
      expect(rocketfuel_service).to have_received(:get_all).with(params)
    end
  end
end
