require 'spec_helper'

RSpec.describe(RackSessionManipulation::Utilities) do
  context 'Module methods' do
    let(:dummy_class) do
      c = Class.new
      c.extend(described_class)
      c
    end

    let(:test_hash) { {'test' => 'hash'} }
    let(:test_json) { JSON.generate(test_hash) }

    it 'encodes hashes with JSON' do
      expect { JSON.parse(dummy_class.encode(test_hash)) }.to_not raise_error
    end

    it 'decodes JSON to hashes' do
      target_json = JSON.generate({ test: 'hash' })
      expect { dummy_class.decode(test_json) }.to_not raise_error
      expect(dummy_class.decode(test_json)).to eql(test_hash)
    end
  end
end
