# frozen_string_literal: true

RSpec.describe 'Kiba::Tanmer::Job' do
  subject do
    Kiba::Tanmer::Job.new
  end

  it { should respond_to :checkpoints }
  it { should respond_to :checkpoint }
  it do
    subject.checkpoints[:foo] = 'bar'
    expect(subject.checkpoint(:foo)).to eq 'bar'
  end

  it 'define with source string' do
    subject.define <<-CODE, 'a-path'
      checkpoints[:store] = []
      source { 1..3 }
      transform { |x| x * 20 }
      destination { |x| checkpoints[:store] << x }
    CODE

    subject.run
    expect(subject.checkpoint(:store)).to eq [20, 40, 60]
  end
end
