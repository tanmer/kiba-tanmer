# frozen_string_literal: true

def check_features!
  it { should respond_to :checkpoints }
  it { should respond_to :checkpoint }
  it 'can set checkpoint' do
    subject.checkpoints[:foo] = 'bar'
    expect(subject.checkpoint(:foo)).to eq 'bar'
  end
  it 'checkpoint returns correct result' do
    subject.run
    expect(subject.checkpoint(:store)).to eq [20, 40, 60]
  end
end

RSpec.describe 'Kiba::Tanmer::Job' do
  let(:etl_source) do
    <<-CODE
      checkpoints[:store] = []
        source { 1..3 }
        transform { |x| x * 20 }
      destination { |x| checkpoints[:store] << x }
    CODE
  end

  let!(:etl_block) do
    proc do
      checkpoints[:store] = []
      source { 1..3 }
      transform { |x| x * 20 }
      destination { |x| checkpoints[:store] << x }
    end
  end

  context 'included from a Class with block' do
    subject do
      Class.new.tap do |klass|
        klass.send :include, Kiba::Tanmer::Job
        klass.define_etl(&etl_block)
      end.new
    end
    check_features!
  end

  context 'included from a Class with source string' do
    subject do
      Class.new.tap do |klass|
        klass.send :include, Kiba::Tanmer::Job
        klass.define_etl(etl_source, __FILE__)
      end.new
    end
    check_features!
  end

  context 'included from a Class with defile_etl' do
    subject do
      Class.new do
        include Kiba::Tanmer::Job
        define_etl do
          checkpoints[:store] = []
          source { 1..3 }
          transform { |x| x * 20 }
          destination { |x| checkpoints[:store] << x }
        end
      end.new
    end
    check_features!
  end
end
