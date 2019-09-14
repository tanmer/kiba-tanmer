# frozen_string_literal: true

RSpec.describe 'Kiba::Tanmer::Blockable' do
  it do
    store = []
    job = Kiba::Tanmer.parse do
      source { 10 }
      transform { |x| x * 2 }
      destination { |x| store << x }
    end
    job.run
    expect(store).to eq [20]
  end

  it do
    store = []
    job = Kiba::Tanmer.parse do
      source { 1..3 }
      transform { |x| x * 2 }
      destination { |x| store << x }
    end
    job.run
    expect(store).to eq [2, 4, 6]
  end
end
