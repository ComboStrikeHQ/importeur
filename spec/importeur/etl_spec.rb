# frozen_string_literal: true

RSpec.describe Importeur::ETL do
  subject(:etl) do
    described_class.new(
      extractor: extractor,
      transformer: transformer,
      loader: loader
    )
  end

  let(:extractor) { instance_double(Proc) }
  let(:transformer) { instance_double(Proc) }
  let(:loader) { instance_double(Proc) }

  let(:extracted_item_1) { instance_double(Object) }
  let(:extracted_item_2) { instance_double(Object) }
  let(:extracted_item_3) { instance_double(Object) }
  let(:transformed_item_1) { instance_double(Hash) }
  let(:transformed_item_2) { nil }
  let(:transformed_item_3) { instance_double(Hash) }

  context 'with new data' do
    before do
      allow(extractor).to receive(:call).and_return(
        [extracted_item_1, extracted_item_2, extracted_item_3].to_enum
      )
    end

    it 'runs the extract, transform and load steps' do
      expect(transformer).to receive(:call).with(extracted_item_1)
        .and_return(transformed_item_1)
      expect(transformer).to receive(:call).with(extracted_item_2)
        .and_return(transformed_item_2)
      expect(transformer).to receive(:call).with(extracted_item_3)
        .and_return(transformed_item_3)
      expect(loader).to receive(:call) do |arg|
        expect(arg).to be_a(Enumerator::Lazy)
        expect(arg.to_a).to eq([transformed_item_1, transformed_item_3])
      end

      etl.call
    end
  end
end
