# frozen_string_literal: true
#
RSpec.describe Importeur::Extractor do
  subject(:extractor) { described_class.new(data_source, cursor, cursor_key) }

  let(:data_source) { instance_double(DataSource, dataset_unique_id: 'abc', items: items) }
  let(:items) { [instance_double(Object)].to_enum }

  let(:cursor) { instance_double(Cursor) }
  let(:cursor_key) { 'cursor-key' }

  describe '#extract' do
    context 'has new data' do
      before do
        allow(cursor).to receive(:read).with(cursor_key).and_return('def')
      end

      it 'returns entities' do
        expect(cursor).to receive(:write).with(cursor_key, 'abc')
        expect(extractor.call.to_a).to eq(items.to_a)
      end
    end

    context 'has no new data' do
      before do
        allow(cursor).to receive(:read).with(cursor_key).and_return('abc')
      end

      it 'returns nil' do
        expect(cursor).not_to receive(:write).with(cursor_key, 'abc')
        expect(extractor.call).to be(nil)
      end
    end
  end
end
