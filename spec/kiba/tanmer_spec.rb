# frozen_string_literal: true

RSpec.describe Kiba::Tanmer do
  it 'has a version number' do
    expect(Kiba::Tanmer::VERSION).not_to be nil
  end

  it { should respond_to :parse }
end
