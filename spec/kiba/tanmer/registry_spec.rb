# frozen_string_literal: true

RSpec.describe Kiba::Tanmer::Registry do
  before do
    stub_const 'RawSource', (Class.new do
      def initialize(raw)
        @raw = raw
      end

      def each
        yield @raw
      end
    end)

    stub_const 'MultiplyTransform', (Class.new do
      def process(x)
        x * 2
      end
    end)

    stub_const 'CollectinDestination', (Class.new do
      def initialize(collector)
        @collector = collector
      end

      def write(x)
        @collector << x
      end
    end)
  end

  it do
    store = []
    job = Kiba::Tanmer.parse do
      register_sources raw: RawSource
      register_transforms multiply: MultiplyTransform
      register_destinations collection: CollectinDestination

      source :raw, 10
      transform :multiply
      destination :collection, store
    end
    job.run
    expect(store).to eq [20]
  end

  it do
    expect do
      store = []
      Kiba::Tanmer.parse do
        register_sources raw: RawSource
        register_transforms multiply: MultiplyTransform

        source :raw, 10
        transform :multiply
        destination :collection, store
      end.run
    end.to raise_error KeyError, 'key not found: :collection'
  end

  it do
    expect do
      Kiba::Tanmer.parse do
        register_sources raw: RawSource

        source :raw, 10
        transform :raw
      end.run
    end.to raise_error KeyError, 'key not found: :raw'
  end

  it do
    expect do
      Kiba::Tanmer.parse do
        source :raw, 10
      end.run
    end.to raise_error KeyError, 'key not found: :raw'
  end
end
