require 'spec_helper'

RSpec.describe(RackSessionManipulation) do
  it 'has a valid version format' do
    expect(RackSessionManipulation::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
