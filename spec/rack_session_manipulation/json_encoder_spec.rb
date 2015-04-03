require 'spec_helper'

RSpec.describe(RackSessionManipulation::JSONEncoder) do
  context 'Module methods' do
    let(:test_hash) { { 'test' => 'hash' } }
    let(:test_json) { JSON.generate(test_hash) }

    it 'encodes hashes with JSON' do
      expect { JSON.parse(described_class.encode(test_hash)) }.to_not raise_error
    end

    it 'decodes JSON to hashes' do
      expect(-> { described_class.decode(test_json) }).to_not raise_error
      expect(described_class.decode(test_json)).to eql(test_hash)
    end
  end
end
