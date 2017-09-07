# frozen_string_literal: true

require 'appnexusapi'

RSpec.describe Importeur::DataSources::Appnexus do
  subject(:data_source) { described_class.new(appnexus_service) }

  let(:appnexus_service) { instance_double(AppnexusApi::AdvertiserService) }
  let(:appnexus_resource) { instance_double(AppnexusApi::Resource) }

  before do
    expect(appnexus_service).to receive(:get_all).and_return([appnexus_resource])
  end

  describe '#items' do
    it 'returns items' do
      expect(data_source.items).to eq([appnexus_resource])
    end
  end

  describe '#dataset_unique_id' do
    it 'returns nil' do
      expect(data_source.dataset_unique_id).to eq('7f112e7b6410e0257d44f0da280ee284')
    end
  end
end
