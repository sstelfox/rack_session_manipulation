require 'spec_helper'

RSpec.describe(RackSessionManipulation::Config) do
  let(:default_config) { RackSessionManipulation::DEFAULT_OPTIONS }

  context 'Encoder Manipulation' do
    let(:placeholder_encoder) { double('Config') }

    it 'sets the default encoder' do
      expect(subject.encoder).to eq(default_config[:encoder])
    end

    it 'allows overriding the encoder' do
      inst = described_class.new(encoder: placeholder_encoder)
      expect(inst.encoder).to eq(placeholder_encoder)
    end

    it 'allows setting the value after initialization' do
      subject.encoder = placeholder_encoder
      expect(subject.encoder).to eq(placeholder_encoder)
    end
  end

  context 'Path Manipulation' do
    it 'sets the default path' do
      expect(subject.path).to eq(default_config[:path])
    end

    it 'allows overriding the path' do
      inst = described_class.new(path: '/new_path')
      expect(inst.path).to eq('/new_path')
    end

    it 'allows setting the value after initialization' do
      subject.path = '/other_path'
      expect(subject.path).to eq('/other_path')
    end
  end
end
