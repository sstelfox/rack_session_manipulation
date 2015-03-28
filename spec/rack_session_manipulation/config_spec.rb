require 'spec_helper'

RSpec.describe(RackSessionManipulation::Config) do
  subject { RackSessionManipulation::Config }
  let(:instance) { subject.new }

  it 'defaults to a nil path' do
    expect(instance.path).to eq(nil)
  end

  it 'allows initializing with a value' do
    inst = subject.new('value')
    expect(inst.path).to eq('value')
  end

  it 'allows resetting the value after initialization' do
    instance.path = 'else'
    expect(instance.path).to eq('else')
  end
end
