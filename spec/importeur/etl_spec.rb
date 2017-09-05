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

  let(:extracted_item) { instance_double(Object) }
  let(:transformed_item) { instance_double(Hash) }

  context 'with new data' do
    before do
      allow(extractor).to receive(:call).and_return([extracted_item].to_enum)
    end

    it 'runs the extract, transform and load steps' do
      expect(transformer).to receive(:call).with(extracted_item)
        .and_return(transformed_item)
      expect(loader).to receive(:call) do |arg|
        expect(arg).to be_a(Enumerator::Lazy)
        expect(arg.to_a).to eq([transformed_item])
      end

      etl.call
    end
  end
end
