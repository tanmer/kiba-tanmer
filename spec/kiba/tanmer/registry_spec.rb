# frozen_string_literal: true

class RawSource
  def initialize(raw)
    @raw = raw
  end

  def each
    yield @raw
  end
end

class MultiplyTransform
  def process(x)
    x * 2
  end
end

class CollectinDestination
  def initialize(collector)
    @collector = collector
  end

  def write(x)
    @collector << x
  end
end

RSpec.describe 'Kiba::Tanmer::Registry' do
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
