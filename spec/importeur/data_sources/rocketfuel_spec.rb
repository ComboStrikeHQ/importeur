# frozen_string_literal: true

require 'rocketfuel_api'

RSpec.describe Importeur::DataSources::Rocketfuel do
  subject(:data_source) { described_class.new(rocketfuel_service) }

  let(:rocketfuel_service)        { instance_double(RocketfuelApi::Service::Company) }
  let(:company_resource)          { instance_double(RocketfuelApi::Resource::Company) }
  let(:specific_company_resource) { instance_double(RocketfuelApi::Resource::Company) }

  let(:params) { { 'filter' => 'value' } }

  before do
    allow(rocketfuel_service)
      .to receive(:get_all)
      .with({})
      .and_return([company_resource])
    allow(rocketfuel_service)
      .to receive(:get_all)
      .with(params)
      .and_return([specific_company_resource])
  end

  describe '#items' do
    it 'returns items' do
      expect(data_source.items).to eq([company_resource])
    end
  end

  describe '#dataset_unique_id' do
    it 'returns a hash' do
      expect(data_source.dataset_unique_id).to eq('a321d32f28c72c4723523a586f0424d6')
    end
  end

  context 'with params' do
    subject(:data_source) { described_class.new(rocketfuel_service, params) }

    it 'pass params to #get_all and returns items' do
      expect(data_source.items).to eq([specific_company_resource])
    end
  end
end
