# frozen_string_literal: true

RSpec.describe 'Kiba::Tanmer::Checkpoint' do
  it do
    store = []
    job = Kiba::Tanmer.parse do
      source { 10 }
      checkpoint :raw
      transform { |x| x * 2 }
      destination { |x| store << x }
    end
    job.run
    expect(job.checkpoints).to eq(raw: 10)
    expect(job.checkpoint(:raw)).to eq 10
  end
end
