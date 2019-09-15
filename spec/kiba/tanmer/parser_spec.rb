# frozen_string_literal: true

RSpec.describe Kiba::Tanmer::Parser do
  subject do
    Class.new do
      extend Kiba::Tanmer::Parser
    end
  end

  it { should respond_to :parse }

  context 'parsed job with block' do
    let(:job) do
      subject.parse do
        checkpoints[:store] = []
        source { 1..3 }
        transform { |x| x * 20 }
        destination { |x| checkpoints[:store] << x }
      end
    end
    it 'class name should be "<Anonymous Job>"' do
      expect(job.class.name).to eq '<Anonymous Job>'
    end
  end
end
