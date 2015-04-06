require 'spec_helper'

RSpec.describe(RackSessionManipulation::Capybara) do
  it 'is included in Capybara::Session' do
    expect(Capybara::Session.ancestors.include?(subject))
  end

  context 'Module methods' do
    let(:dummy_class) do
      c = Class.new
      c.include(described_class)
      c
    end

    let(:instance) { dummy_class.new }

    it 'retrieves the session\'s data' do
      response_double = double(body: JSON.generate('test' => 'hash'))
      driver_double = double(get: nil, response: response_double)

      allow(instance).to receive(:driver).and_return(driver_double)
      expect(instance.session).to eq('test' => 'hash')
    end

    it 'puts the session\'s data' do
      path = instance.session_manipulation_config.path
      params = { 'session_data' => JSON.generate('content' => 'text') }

      driver_double = double
      allow(instance).to receive(:driver).and_return(driver_double)
      expect(driver_double).to receive(:put).with(path, params)

      instance.session = { 'content' => 'text' }
    end

    it 'responds to session getter' do
      expect(instance).to respond_to(:session)
      expect(instance.method(:session).arity).to eq(0)
    end

    it 'responds to session setter' do
      expect(instance).to respond_to(:session=)
      expect(instance.method(:session=).arity).to eq(1)
    end
  end
end
