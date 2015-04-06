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

    let(:config)        { RackSessionManipulation::Config.new }
    let(:driver_double) { double }
    let(:instance)      { dummy_class.new }
    let(:path)          { config.path }

    before(:each) do
      allow(instance).to receive(:driver).and_return(driver_double)
    end

    it 'responds to session getter' do
      expect(instance).to respond_to(:session)
      expect(instance.method(:session).arity).to eq(0)
    end

    it 'responds to session resetter' do
      expect(instance).to respond_to(:session_reset)
      expect(instance.method(:session_reset).arity).to eq(0)
    end

    it 'responds to session setter' do
      expect(instance).to respond_to(:session=)
      expect(instance.method(:session=).arity).to eq(1)
    end

    context 'Full driver support' do
      it 'deletes the session\'s data' do
        expect(driver_double).to receive(:delete).with(config.path, {})
        instance.session_reset
      end

      it 'retrieves the session\'s data' do
        data = { 'user_id' => 10 }
        response_double = double(body: config.encoder.encode(data))

        expect(driver_double).to receive(:get).with(config.path)
        expect(driver_double).to receive(:response).and_return(response_double)

        instance.session
      end

      it 'puts the session\'s data' do
        params = { 'session_data' => JSON.generate('content' => 'text') }
        expect(driver_double).to receive(:put).with(path, params)

        instance.session = { 'content' => 'text' }
      end
    end

    context 'Partial driver support' do
      it 'deletes the session\'s data' do
        expect(driver_double).to_not respond_to(:delete)
        expect(driver_double).to receive(:post).with(config.path, { '_method' => 'DELETE' })

        instance.session_reset
      end

      it 'puts the session\'s data' do
        params = {
          '_method' => 'PUT',
          'session_data' => JSON.generate('misc' => 'test')
        }

        expect(driver_double).to_not respond_to(:put)
        expect(driver_double).to receive(:post).with(config.path, params)

        instance.session = { 'misc' => 'test' }
      end
    end

    context 'Minimal driver support' do
      it 'deletes the session\'s data' do
        expect(driver_double).to_not respond_to(:delete)
        expect(driver_double).to receive(:get).with(config.path, { '_method' => 'DELETE' })

        instance.session_reset
      end

      it 'puts the session\'s data' do
        params = {
          '_method' => 'PUT',
          'session_data' => JSON.generate('misc' => 'test')
        }

        expect(driver_double).to_not respond_to(:put)
        expect(driver_double).to receive(:get).with(config.path, params)

        instance.session = { 'misc' => 'test' }
      end
    end
  end
end
