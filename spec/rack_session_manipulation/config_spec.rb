require 'spec_helper'

RSpec.describe(RackSessionManipulation::Config) do
  it 'defaults to a nil path' do
    expect(subject.path).to eq(nil)
  end

  it 'allows initializing with a value' do
    inst = described_class.new('value')
    expect(inst.path).to eq('value')
  end

  it 'allows resetting the value after initialization' do
    subject.path = 'else'
    expect(subject.path).to eq('else')
  end
end
