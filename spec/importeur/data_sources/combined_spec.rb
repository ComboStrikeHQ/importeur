# frozen_string_literal: true

require 'bucket_cake'

RSpec.describe Importeur::DataSources::Combined do
  subject(:combined_feed) do
    described_class.new(BucketCake::Entities::Affiliates, BucketCake::Entities::Advertisers)
  end

  let(:feed1) do
    instance_double(BucketCake::Entities::Affiliates, items: [1])
  end

  let(:feed2) do
    instance_double(BucketCake::Entities::Advertisers, items: [2])
  end

  before do
    allow(BucketCake::Entities::Affiliates).to receive(:new).and_return(feed1)
    allow(BucketCake::Entities::Advertisers).to receive(:new).and_return(feed2)
  end

  describe '#dataset_unique_id' do
    it 'returns a combined unique ID' do
      expect(feed1).to receive(:dataset_unique_id).and_return('1')
      expect(feed2).to receive(:dataset_unique_id).and_return('2')
      expect(combined_feed.dataset_unique_id).to eq('12')
    end
  end

  describe '#items' do
    it "combines the feeds' items" do
      expect(combined_feed.items.to_a).to eq(feed1.items + feed2.items)
    end
  end
end
